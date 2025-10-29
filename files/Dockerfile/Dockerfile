# Copyright (c) 2022-2023 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

# IMAGE_OS argument, bionic or focal
ARG IMAGE_OS

# Start base image
FROM ubuntu:${IMAGE_OS}

# IMAGE_OS argument, bionic or focal
ARG IMAGE_OS
RUN echo "IMAGE_OS is $IMAGE_OS"

# Install needed ubuntu packets
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y sudo python2.7 gnupg flex bison screen tree mc   \
    build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 libncurses5   \
    lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils   \
    xsltproc unzip fontconfig python3 clang cmake python3-pip texinfo chrpath diffstat         \
    xmlstarlet libarchive-dev ssh libselinux1-dev g++ gawk gcc make libwayland-dev fakeroot    \
    libpam0g-dev openjdk-8-jdk-headless binutils-dev util-linux uuid-dev zstd cpio whiptail    \
    libxml-simple-perl git vim openssl software-properties-common                              \
    locales gdb lcov libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev usbutils             \
    liblzma-dev libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev lzma lzma-dev       \
    tk-dev file language-pack-en-base wget android-tools-adb android-tools-fastboot         && \
    apt install -y fakechroot gcc-aarch64-linux-gnu g++-aarch64-linux-gnu libiberty-dev jq \
    bash-completion qemu-user-static liblz4-tool git-core python3-pexpect socat xz-utils iputils-ping \
    python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm rsync python qemu-user     && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/*

# Install additional dependencies
RUN rm -rf /lib/ld-linux-aarch64.so.1                                                           && \
    ln -sf /usr/aarch64-linux-gnu/lib/ld-2.31.so /lib/ld-linux-aarch64.so.1                     && \
    ln -sf /bin/bash /bin/sh                                                                    && \
    QEMU_PACKAGE=$(wget -q -O - http://archive.ubuntu.com/ubuntu/pool/universe/q/qemu/           | \
    grep -o '"qemu-user-static_6.2+dfsg-2ubuntu*.*.deb"' | sort -V | head -1 | tr -d '"')       && \
    wget --quiet http://archive.ubuntu.com/ubuntu/pool/universe/q/qemu/${QEMU_PACKAGE}          && \
    dpkg -i ${QEMU_PACKAGE}                                                                     && \
    rm -rf ${QEMU_PACKAGE}

# Set python2.7 as python2
RUN update-alternatives --install /usr/bin/python2 python2 /usr/bin/python2.7 10

# Set python alternatives
RUN if [ "$IMAGE_OS" == "bionic" ]; then  \
        update-alternatives --install /usr/bin/python python /usr/bin/python3 1;  \
        update-alternatives --install /usr/bin/python python /usr/bin/python2 10; \
    elif [ "$IMAGE_OS" == "focal" ]; then  \
        update-alternatives --install /usr/bin/python python /usr/bin/python3 10; \
        update-alternatives --install /usr/bin/python python /usr/bin/python2 1; \
    fi

# Set SHELL
ENV SHELL=/bin/bash
RUN ln -fs /bin/bash /bin/sh

# Set LANG
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# Input arguments
ARG HOST_USER_ID
ARG HOST_USER
ARG HOST_GROUP_ID
ARG HOST_GROUP
ARG USER_EMAIL

# Create user
# Group users lists logged users and cannot be manually created
RUN [ "$HOST_GROUP" != "users" ]                                          && \
    addgroup --gid ${HOST_GROUP_ID} ${HOST_GROUP}                         || \
    true
RUN useradd -s /bin/bash -m -g ${HOST_GROUP} -u ${HOST_USER_ID} ${HOST_USER}
RUN usermod -aG sudo ${HOST_USER}
RUN echo ${HOST_USER}:pass | chpasswd

# set user
USER $HOST_USER

# git config
RUN git config --global user.name "${HOST_USER}"   && \
    git config --global user.email "${USER_EMAIL}"

