# SPDX-License-Identifier: BSD-3-Clause
#
# Authors: Alexander Jung <alexander.jung@neclab.eu>
#
# Copyright (c) 2020, NEC Europe Ltd., NEC Corporation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

FROM alpine:3.10 AS linuxk-build

LABEL MAINTAINER="Alexander Jung <a.jung@lancs.ac.uk>"

ARG LINUXK_VERSION
ARG EXTRA
ARG DEBUG
ARG UK_ARCH

RUN set -x; \
    apk --no-cache add \
        argp-standalone \
        automake \
        bash \
        bc \
        binutils-dev \
        bison \
        build-base \
        curl \
        diffutils \
        flex \
        git \
        gmp-dev \
        gnupg \
        installkernel \
        iucode-tool \
        kmod \
        elfutils-dev \
        linux-headers \
        mpc1-dev \
        mpfr-dev \
        ncurses-dev \
        openssl-dev \
        patch \
        rsync \
        sed \
        squashfs-tools \
        tar \
        xz \
        xz-dev \
        zlib-dev

# libunwind-dev pkg is missed from arm64 now, below statement will be removed if the pkg is available.
RUN [ ${UK_ARCH} == x86_64 ] && apk add --no-cache libunwind-dev || true

COPY keys.asc /

# Download and verify kernel
# PGP keys: 589DA6B1 (greg@kroah.com)
#           6092693E (autosigner@kernel.org)
#           00411886 (torvalds@linux-foundation.org)
RUN set -ex; \
    KERNEL_MAJOR=$(echo ${LINUXK_VERSION} | cut -d . -f 1); \
    KERNEL_MAJOR=v${KERNEL_MAJOR}.x; \
    KERNEL_SERIES=$(echo ${LINUXK_VERSION} | cut -d . -f 1-2); \
    KERNEL_SOURCE=https://www.kernel.org/pub/linux/kernel/${KERNEL_MAJOR}/linux-${LINUXK_VERSION}.tar.xz; \
    KERNEL_SHA256_SUMS=https://www.kernel.org/pub/linux/kernel/${KERNEL_MAJOR}/sha256sums.asc; \
    KERNEL_PGP2_SIGN=https://www.kernel.org/pub/linux/kernel/${KERNEL_MAJOR}/linux-${LINUXK_VERSION}.tar.sign; \
    curl -fsSLO ${KERNEL_SHA256_SUMS}; \
    gpg2 -q --import keys.asc; \
    gpg2 --verify sha256sums.asc; \
    KERNEL_SHA256=$(grep linux-${LINUXK_VERSION}.tar.xz sha256sums.asc | cut -d ' ' -f 1); \
    [ -f linux-${LINUXK_VERSION}.tar.xz ] || curl -fsSLO ${KERNEL_SOURCE}; \
    echo "${KERNEL_SHA256}  linux-${LINUXK_VERSION}.tar.xz" | sha256sum -c -; \
    xz -d linux-${LINUXK_VERSION}.tar.xz; \
    curl -fsSLO ${KERNEL_PGP2_SIGN}; \
    gpg2 --verify linux-${LINUXK_VERSION}.tar.sign linux-${LINUXK_VERSION}.tar; \
    cat linux-${LINUXK_VERSION}.tar | tar --absolute-names -x && mv /linux-${LINUXK_VERSION} /linux

RUN mkdir -p /out/src

WORKDIR /tmp
# Download Intel ucode, create a CPIO archive for it, and keep it in the build context
# so the firmware can also be referenced with CONFIG_EXTRA_FIRMWARE
ENV UCODE_REPO=https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files
ENV UCODE_COMMIT=microcode-20191115
RUN set -ex; \
    if [ "${UK_ARCH}" == "x86_64" ]; then \
        git clone ${UCODE_REPO} ucode; \
        cd ucode; \
        git checkout ${UCODE_COMMIT}; \
        iucode_tool --normal-earlyfw --write-earlyfw=/out/intel-ucode.cpio ./intel-ucode; \
        cp license /out/intel-ucode-license.txt; \
        mkdir -p /lib/firmware; \
        cp -rav ./intel-ucode /lib/firmware; \
    fi

WORKDIR /linux

# Save kernel source
RUN tar cJf /out/src/linux.tar.xz /linux

# Kernel config
RUN set -x; \
    case ${UK_ARCH} in \
      x86_64) \
        KERNEL_DEF_CONF=/linux/arch/x86/configs/x86_64_defconfig; \
        ;; \
      arm64) \
        KERNEL_DEF_CONF=/linux/arch/arm64/configs/defconfig; \
        ;; \
    esac; \
    cp /config-${KERNEL_SERIES}-${UK_ARCH} ${KERNEL_DEF_CONF}; \
    if [ -n "${EXTRA}" ] && [ -f "/config-${KERNEL_SERIES}-${UK_ARCH}${EXTRA}" ]; then \
        cat /config-${KERNEL_SERIES}-${UK_ARCH}${EXTRA} >> ${KERNEL_DEF_CONF}; \
    fi; \
    sed -i "s/CONFIG_LOCALVERSION=\"-unikraft\"/CONFIG_LOCALVERSION=\"-unikraft${EXTRA}${DEBUG}\"/" ${KERNEL_DEF_CONF}; \
    if [ -n "${DEBUG}" ]; then \
        sed -i 's/CONFIG_PANIC_ON_OOPS=y/# CONFIG_PANIC_ON_OOPS is not set/' ${KERNEL_DEF_CONF}; \
        cat /config${DEBUG} >> ${KERNEL_DEF_CONF}; \
    fi; \
    make defconfig; \
    make oldconfig;

# Kernel
RUN set -x; \
    make -j "$(getconf _NPROCESSORS_ONLN)" KCFLAGS="-fno-pie"; \
    case ${UK_ARCH} in \
      x86_64) \
        cp arch/x86_64/boot/bzImage /out/kernel; \
        ;; \
      arm64) \
        cp arch/arm64/boot/Image.gz /out/kernel; \
        ;; \
    esac; \
    cp System.map /out; \
    ([ -n "${DEBUG}" ] && cp vmlinux /out || true)

# Modules and Device Tree binaries
RUN make INSTALL_MOD_PATH=/tmp/kernel-modules modules_install; \
    ( DVER=$(basename $(find /tmp/kernel-modules/lib/modules/ -mindepth 1 -maxdepth 1)); \
      cd /tmp/kernel-modules/lib/modules/$DVER &&; \
      rm build source; \
      ln -s /usr/src/linux-headers-$DVER build ); \
    case ${UK_ARCH} in \
      aarch64) \
        make INSTALL_DTBS_PATH=/tmp/kernel-modules/boot/dtb dtbs_install; \
        ;; \
    esac; \
        ( cd /tmp/kernel-modules && tar cf /out/kernel.tar . )

# Headers (userspace API)
RUN mkdir -p /tmp/kernel-headers/usr; \
    make INSTALL_HDR_PATH=/tmp/kernel-headers/usr headers_install; \
    ( cd /tmp/kernel-headers && tar cf /out/kernel-headers.tar usr )

# Headers (kernel development)
RUN DVER=$(basename $(find /tmp/kernel-modules/lib/modules/ -mindepth 1 -maxdepth 1)); \
    dir=/tmp/usr/src/linux-headers-$DVER; \
    mkdir -p $dir; \
    cp /linux/.config $dir; \
    cp /linux/Module.symvers $dir; \
    find . -path './include/*' -prune -o \
           -path './arch/*/include' -prune -o \
           -path './scripts/*' -prune -o \
           -type f \( -name 'Makefile*' -o -name 'Kconfig*' -o -name 'Kbuild*' -o \
                      -name '*.lds' -o -name '*.pl' -o -name '*.sh' -o \
                      -name 'objtool' -o -name 'fixdep' -o -name 'randomize_layout_seed.h' \) | \
    tar cf - -T - | (cd $dir; tar xf -); \
    ( cd /tmp && tar cf /out/kernel-dev.tar usr/src )

RUN printf "KERNEL_SOURCE=${KERNEL_SOURCE}\n" > /out/kernel-source-info

FROM scratch AS linux
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=linuxk-build /out/* /
