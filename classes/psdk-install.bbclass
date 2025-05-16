# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
ARTIFACTS_NAME = "artifacts"
TARGET_SDK_PATH ?= "/usr/"

PV = "1.0.0"
PR = "r0"
COPY_PACKAGES ?= "1"

python do_install() {
    import os
    import subprocess
    import shutil
    import json
    from pathlib import Path
    import glob

    #copy the files hosted in directory data to specific one
    def migrate_package_data_dir(src_dir,dest_dir):
        data_dir_list = list()
        # collect the all directory to list
        for dirpath, dirnames, filenames in os.walk(src_dir):
            if "data" in dirnames:  # if include data dir
                data_dir = os.path.join(dirpath, "data")
                data_dir_list.append(data_dir)

        # according to list to execute the cp command by new subprocess
        # copy data directory from origin to ${D}
        for data_dir in data_dir_list:
            base_dir = data_dir
            # if base_dir exist and not empty ,copy to the package baisc path
            if os.path.exists(base_dir) and os.listdir(base_dir):
                copy_cmd = "cp -r %s/* %s" %(data_dir,dest_dir)
                bb.note(copy_cmd)
                subprocess.call(copy_cmd,shell=True)
            else:
                bb.note("do_install: There has no data dir after unpacked")

    # pending
    # Pick up files with configure file from D
    # input:
    #     config_path: the path of configure file
    #     filepath_in: the path of file
    #     filepath_out: the path of pick-up outputs
    #     pickup_record: a file to record the pick-up files
    def pickup_files(config_path, filepath_in, filepath_out, pickup_record):
        path = Path(config_path)
        bb.note("config file: %s" %path)
        if not path.exists():
            bb.fatal("config file: %s not exist" %path)
            return
        config = json.load(path.open(mode='r'))
        bb.note("function sdk info is below: %s" %config['function_sdks'])
        filelist = os.path.join(d.getVar('D'),pickup_record)
        with open(filelist, 'w+') as record:
            record.write('first line \n')
            for sdk in config['function_sdks']:
                recipe_name = d.getVar("PN")
                if recipe_name != sdk['name']:
                    continue
                bb.note("function sdk name is below: %s" %sdk['name'])
                bb.note("function sdk pickup_files is below: %s" %sdk['pickup_files'])
                for pick in sdk['pickup_files']:
                    for src in pick['from']:
                        to_path = filepath_out + "/" + pick['to']
                        from_path = os.path.join(filepath_in,src)
                        bb.note("to_path: %s" %to_path)
                        bb.note("from_path: %s" %from_path)
                        directory = from_path
                        for f in glob.glob(from_path):
                            bb.note("f = %s" %f)
                            if not os.path.islink(f) and not os.path.exists(f):
                                bb.fatal("%s is not exsit, please check your config file" %f)
                            if not (os.path.exists(to_path[:to_path.rfind("/")])):
                                bb.note("%s is not exist, have create it firstly" %to_path[:to_path.rfind("/")])
                                os.makedirs(to_path[:to_path.rfind("/")])
                            bb.note("pick from <%s> to <%s>" %(f,to_path))
                            copy_cmd = "cp -rf %s %s" %(f,to_path)
                            subprocess.call(copy_cmd,shell=True)
                            record.write(f + '\n')
    def migrate_package(src_dir,dest_dir):
        directory = src_dir
        target_package_folder = dest_dir
        bb.note(target_package_folder)
        #move package to artifacts factory(deb/ipk etc...)
        for dirpath, dirnames, filenames in os.walk(directory):
            for file in filenames:
                if file.endswith('.'+d.getVar("IMAGE_PKGTYPE")):
                    pkg_file = os.path.join(dirpath, file)
                    mv_cmd = "cp -f %s %s ; rm -f %s" %(pkg_file, target_package_folder,pkg_file)
                    bb.note(mv_cmd)
                    subprocess.call(mv_cmd,shell=True)
    def disregrad_skipfile():
        rm_cmd = "rm -rf %s" %d.getVar("FILES_SKIP")
        bb.note(rm_cmd)
        subprocess.call(rm_cmd,shell=True)

    image_path = d.getVar("D")
    image_temp_path = "{}_{}".format(image_path,"temp")
    #copy real file from each package data directory to ${D}_temp
    migrate_package_data_dir(d.getVar("S"),image_temp_path)
    if d.getVar("COPY_PACKAGES") == "1":
        migrate_package(d.getVar("S"),os.path.join(d.getVar("FCUNTION_ARTIFACTS_TMP"),"packages"))
    disregrad_skipfile()

    outputdir = d.getVar('D')
    artifacts_input = image_temp_path
    # config file setting
    config_file = d.getVar('CONFIG_SELECT')
    absolute_config_path = d.getVar("FILE_DIRNAME") + "/../files/" + config_file
    configfile_oss = Path(absolute_config_path)
    fileslist = "pickup_files_list_oss_" + d.getVar("PN")

    pickup_files(configfile_oss, artifacts_input, outputdir, fileslist)

    # move files_list to data dir
    fileslist_path = os.path.join(outputdir,os.path.join(d.getVar("TARGET_SDK_PATH"),"data"))
    mv_cmd = "mkdir -p %s && mv %s %s" %(fileslist_path, os.path.join(outputdir,fileslist), fileslist_path)
    bb.note(mv_cmd)
    subprocess.call(mv_cmd,shell=True)
}
do_install[dirs] += "${FCUNTION_ARTIFACTS_TMP} ${FCUNTION_ARTIFACTS_TMP}/packages ${FCUNTION_ARTIFACTS_TMP}/sample/${PN} ${FCUNTION_ARTIFACTS_TMP}/scripts/${PN}"
do_install[dirs] += "${D}_temp"
do_install[cleandirs] += "${FCUNTION_ARTIFACTS_TMP}"

do_generate_artifacts_base(){
    mkdir -p ${FCUNTION_ARTIFACTS_TMP}/packages
    mkdir -p ${FCUNTION_ARTIFACTS_TMP}/sample/${PN}
    mkdir -p ${FCUNTION_ARTIFACTS_TMP}/scripts/${PN}
}
do_install[prefuncs] += "do_generate_artifacts_base"

do_generate_artifacts(){
    mkdir -p ${FCUNTION_ARTIFACTS_TMP}/sample/${PN}
    FILE_PATH="${DEPLOY_DIR}/${IMAGE_PKGTYPE}/${PACKAGE_ARCH}/${PN}_${PV}-${PR}*.${IMAGE_PKGTYPE}"
    while ! ls $FILE_PATH 1> /dev/null 2>&1 ;do
        bbwarn "${PN}_${PV}-${PR}*.${IMAGE_PKGTYPE} is not found ,wait 10s seconds for generation..."
        sleep 10
    done
    bbnote "${PN}_${PV}-${PR}*.${IMAGE_PKGTYPE} found"
    cp ${DEPLOY_DIR}/${IMAGE_PKGTYPE}/${PACKAGE_ARCH}/*${PN}*_${PV}-${PR}*.${IMAGE_PKGTYPE} ${FCUNTION_ARTIFACTS_TMP}/packages/
    cp -r ${FCUNTION_ARTIFACTS_TMP}/* ${SSTATE_IN_DIR}
}

addtask do_generate_artifacts_setscene
SSTATE_OUT_DIR = "${DEPLOY_DIR}/${ARTIFACTS_NAME}/${PN}_artifacts/"
SSTATE_IN_DIR = "${TOPDIR}/${PN}"
FCUNTION_ARTIFACTS_TMP = "${TOPDIR}/${PN}_tmp"

SSTATETASKS += "do_generate_artifacts"
do_generate_artifacts[sstate-inputdirs] = "${SSTATE_IN_DIR}"
do_generate_artifacts[sstate-outputdirs] = "${SSTATE_OUT_DIR}"
do_generate_artifacts[dirs] = "${SSTATE_IN_DIR} ${SSTATE_OUT_DIR} "
do_generate_artifacts[cleandirs] = "${SSTATE_IN_DIR} ${SSTATE_OUT_DIR} "
do_generate_artifacts[stamp-extra-info] = "${MACHINE_ARCH}"

python __anonymous () {
    package_type = d.getVar("IMAGE_PKGTYPE", True)
    bb.build.addtask('do_generate_artifacts','do_build','do_package_write_{}'.format(package_type),d)
}

SYSROOT_DIRS = "/${DIRNAME}/"
#FILES:${PN} += "${TARGET_SDK_PATH}"
do_package_qa[noexec] = "1"

INSANE_SKIP:${PN} += "already-stripped installed-vs-shipped"
INHIBIT_SYSROOT_STRIP = "1"
EXCLUDE_FROM_SHLIBS = "1"
