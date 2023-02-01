# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
#
# Dockerfile to Mariner toolchain from scratch
#
FROM mcr.microsoft.com/cbl-mariner/base/core:1.0.20220226

# Define LFS root directory and setup environment variables
ENV LFS=/temptoolchain/lfs
ENV LC_ALL=POSIX
ENV PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin

COPY [ "./version-check-container.sh", \
       "$LFS/tools/" ]

# Install toolchain build dependencies
RUN tdnf install -y \
    bison \
    build-essential \
    byacc \
    ca-certificates \
    ccache \
    cpio \
    file \
    flex \
    gawk \
    gcc \
    make \
    patch \
    perl \
    rpm \
    sudo \
    texinfo \
    unzip \
    vim \
    wget \
    zip && \
    ln    -sf bash /bin/sh && \
    mkdir -pv $LFS/sources && \
    chmod -v a+wt $LFS/sources && \
    mkdir -pv $LFS/logs/temptoolchain && \
    mkdir -pv $LFS/tools && \
    ln    -sv $LFS/tools / && \
    $LFS/tools/version-check-container.sh

COPY [ "./toolchain-sha256sums", \
       "./toolchain-remote-wget-list", \
       "./toolchain-local-wget-list", \
       "./rpm-define-RPM-LD-FLAGS.patch", \
       "./linker-script-readonly-keyword-support.patch", \
       "$LFS/tools/" ]

# Download source, then create lfs user and group.
# Append "; exit 0" after wget commands to ignore download errors that might be expected. The sha256sum command will verify all downloads.
# Note: Fetch the kernel sources differently to ensure we rename the source tarball appropriately. The rename is needed to comply with
# the naming convention of the source cache (convention used to prevent naming collisions).
WORKDIR $LFS/sources
RUN wget -nv --no-clobber --timeout=30 --continue --input-file=$LFS/tools/toolchain-local-wget-list --directory-prefix=$LFS/sources; exit 0
RUN wget -nv --no-clobber --timeout=30 --continue --input-file=$LFS/tools/toolchain-remote-wget-list --directory-prefix=$LFS/sources; exit 0
RUN wget -nv --no-clobber --timeout=30 --continue https://github.com/microsoft/CBL-Mariner-Linux-Kernel/archive/rolling-lts/mariner-2/5.15.48.1.tar.gz -O kernel-5.15.48.1.tar.gz --directory-prefix=$LFS/sources; exit 0
USER root
RUN sha256sum -c $LFS/tools/toolchain-sha256sums && \
    groupadd lfs && \
    useradd -s /bin/bash -g lfs -m -k /dev/null lfs && \
    echo "lfs:lfscblmariner" | chpasswd && \
    usermod -a -G sudo lfs && \
    chown -v lfs $LFS/tools && \
    chown -v lfs $LFS/sources && \
    chown -Rv lfs $LFS/logs && \
    echo "lfs ALL = NOPASSWD : ALL" >> /etc/sudoers && \
    echo 'Defaults env_keep += "LFS LC_ALL LFS_TGT PATH MAKEFLAGS FETCH_TOOLCHAIN_MODE LFS_TEST LFS_DOCS JOB_COUNT LOOP IMAGE_SIZE INITRD_TREE IMAGE"' >> /etc/sudoers

RUN echo "exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash" >> /home/lfs/.bash_profile
COPY [ "./.bashrc", \
       "/home/lfs/" ]

USER lfs
COPY [ "./toolchain_build_temp_tools.sh", \
       "./coreutils-fix-get-sys_getdents-aarch64.patch", \
       "$LFS/tools/" ]

USER root
RUN  chown -Rv lfs $LFS/tools && \
     chown -Rv lfs:lfs /home/lfs/

USER lfs
RUN /tools/toolchain_build_temp_tools.sh

COPY [ "./toolchain_initial_chroot_setup.sh", \
       "./toolchain_build_in_chroot.sh", \
       "./mount_chroot_start_build.sh", \
       "./unmount_chroot.sh", \
       "./go14_bootstrap_aarch64.patch", \
       "./rpm-define-RPM-LD-FLAGS.patch", \
       "./cpio_extern_nocommon.patch", \
       "./CVE-2021-38185.patch", \
       "./CVE-2021-36690.patch", \
       "$LFS/tools/" ]

USER root

ENTRYPOINT [ "/tools/mount_chroot_start_build.sh" ]
