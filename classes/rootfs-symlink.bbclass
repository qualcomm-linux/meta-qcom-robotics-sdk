#Copyright (c) 2026 Qualcomm Innovation Center, Inc. All rights reserved.
#SPDX-License-Identifier: BSD-3-Clause-Clear

do_rootfs_create_symlinks() {
    :
}

python do_rootfs_create_symlinks () {
    import os
    import subprocess

    dvar = d.getVar('IMAGE_ROOTFS')  
    pairs = d.getVar('ROOTFS_SYMLINK_PAIRS') or ""
    pairs = pairs.split()

    if not pairs:
        bb.note("rootfs-symlink: ROS_SYMLINK_PAIRS not set, skip")
        return

    for p in pairs:
        if ':' in p:
            src, dest = p.split(':', 1)
        else:
            parts = p.split(None, 1)
            if len(parts) != 2:
                bb.warn(f"rootfs-symlink: can't parse '{p}', should be 'SRC:DEST' or 'SRC DEST', skip")
                continue
            src, dest = parts

        src = src.strip()
        dest = dest.strip()

        if not src or not dest:
            bb.warn(f"rootfs-symlink: empty SRC/DEST（'{p}', skip")
            continue

        abs_dest = os.path.join(dvar, dest.lstrip('/'))
        dest_dir = os.path.dirname(abs_dest)

        os.makedirs(dest_dir, exist_ok=True)

        try:
            subprocess.check_call(['ln', '-snf', src, abs_dest])
            bb.note(f"rootfs-symlink: ln -snf {src} -> {abs_dest}")
        except subprocess.CalledProcessError as e:
            bb.fatal(f"rootfs-symlink: create link fail : {src} -> {abs_dest}, error ：{e}")
}

ROOTFS_POSTPROCESS_COMMAND:append = " do_rootfs_create_symlinks; "
