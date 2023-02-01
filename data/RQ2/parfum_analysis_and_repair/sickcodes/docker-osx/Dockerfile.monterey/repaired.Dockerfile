#!/usr/bin/docker
#     ____             __             ____  ______  __
#    / __ \____  _____/ /_____  _____/ __ \/ ___/ |/ /
#   / / / / __ \/ ___/ //_/ _ \/ ___/ / / /\__ \|   /
#  / /_/ / /_/ / /__/ ,< /  __/ /  / /_/ /___/ /   |
# /_____/\____/\___/_/|_|\___/_/   \____//____/_/|_| [MONTEREY]
#
# Title:            Docker-OSX (Mac on Docker)
# Author:           Sick.Codes https://twitter.com/sickcodes
# Version:          6.0
# License:          GPLv3+
# Repository:       https://github.com/sickcodes/Docker-OSX
# Website:          https://sick.codes
# 
# Notes:            Uses a self-hosted BaseSystem.img from a USB installer.
#                   If you want to DIY, use https://github.com/corpnewt/gibMacOS
#                   Set seed as developer, and install the Install Assistant on Big Sur
#                   Burn to a USB, and pull out BaseSystem.img
#                   Or download from https://images.sick.codes/BaseSystem_Monterey.dmg
# 

FROM sickcodes/docker-osx

MAINTAINER 'https://twitter.com/sickcodes' <https://sick.codes>

SHELL ["/bin/bash", "-c"]

# change disk size here or add during build, e.g. --build-arg VERSION=10.14.5 --build-arg SIZE=50G
ARG SIZE=200G
ARG BASE_SYSTEM='https://images.sick.codes/BaseSystem_Monterey.dmg'

WORKDIR /home/arch/OSX-KVM

RUN wget -O BaseSystem.dmg "${BASE_SYSTEM}" \
    && qemu-img convert BaseSystem.dmg -O qcow2 -p -c BaseSystem.img \
    && rm -f BaseSystem.dmg

RUN qemu-img create -f qcow2 /home/arch/OSX-KVM/mac_hdd_ng.img "${SIZE}"

WORKDIR /home/arch/OSX-KVM

#### libguestfs versioning

# 5.13+ problem resolved by building the qcow2 against 5.12 using libguestfs-1.44.1-6

ENV SUPERMIN_KERNEL=/boot/vmlinuz-linux
ENV SUPERMIN_MODULES=/lib/modules/5.12.14-arch1-1
ENV SUPERMIN_KERNEL_VERSION=5.12.14-arch1-1
ENV KERNEL_PACKAGE_URL=https://archive.archlinux.org/packages/l/linux/linux-5.12.14.arch1-1-x86_64.pkg.tar.zst
ENV KERNEL_HEADERS_PACKAGE_URL=https://archive.archlinux.org/packages/l/linux/linux-headers-5.12.14.arch1-1-x86_64.pkg.tar.zst
ENV LIBGUESTFS_PACKAGE_URL=https://archive.archlinux.org/packages/l/libguestfs/libguestfs-1.44.1-6-x86_64.pkg.tar.zst

ARG LINUX=true

# required to use libguestfs inside a docker container, to create bootdisks for docker-osx on-the-fly
RUN if [[ "${LINUX}" == true ]]; then \
        sudo pacman -U "${KERNEL_PACKAGE_URL}" --noconfirm \
        ; sudo pacman -U "${LIBGUESTFS_PACKAGE_URL}" --noconfirm \
        ; sudo pacman -U "${KERNEL_HEADERS_PACKAGE_URL}" --noconfirm \
        ; sudo pacman -S mkinitcpio --noconfirm \
        ; sudo libguestfs-test-tool \
        ; sudo rm -rf /var/tmp/.guestfs-* \
    ; fi

####


# optional --build-arg to change branches for testing
ARG BRANCH=master
ARG REPO='https://github.com/sickcodes/Docker-OSX.git'
# RUN git clone --recurse-submodules --depth 1 --branch "${BRANCH}" "${REPO}"