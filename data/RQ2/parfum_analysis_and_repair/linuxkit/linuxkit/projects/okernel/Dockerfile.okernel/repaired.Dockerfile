FROM linuxkit/alpine:07f7d136e427dc68154cd5edbb2b9576f9ac5213 AS kernel-build
RUN apk --no-cache add \
    argp-standalone \
    automake \
    bash \
    bc \
    binutils-dev \
    bison \
    build-base \
    curl \
    diffutils \
    git \
    installkernel \
    kmod \
    libelf-dev \
    linux-headers \
    sed \
    tar \
    xz \
    zlib-dev \
    openssl \
    openssl-dev

ARG KERNEL_VERSION
ARG DEBUG=0

ENV OKERNEL_SOURCE=https://github.com/linux-okernel/linux-okernel/archive/${KERNEL_VERSION}.tar.gz
ENV USPACE_SOURCE=https://github.com/linux-okernel/linux-okernel-components/archive/master.tar.gz

RUN if [ -n $HTTP_PROXY ]; then \
    curl -fsSL -x ${HTTP_PROXY} -o linux-${KERNEL_VERSION}.tar.gz ${OKERNEL_SOURCE}; \
    else \
    curl -fsSL -o linux-${KERNEL_VERSION}.tar.gz ${OKERNEL_SOURCE}; \
    fi

RUN cat linux-${KERNEL_VERSION}.tar.gz | tar --absolute-names -xz && mv /linux-okernel-${KERNEL_VERSION} /linux

COPY kernel_config.okernel /linux/.config

RUN mkdir /out

# Kernel
RUN cd /linux && \
    make oldconfig && \
    make -j "$(getconf _NPROCESSORS_ONLN)" KCFLAGS="-fno-pie" && \
    cp arch/x86_64/boot/bzImage /out/kernel && \
    cp System.map /out && \
    cp vmlinux /out

# Modules & Headers (userspace API)
RUN cd /linux && \
    make INSTALL_MOD_PATH=/tmp/kernel-modules modules_install && \
    ( DVER=$(basename $(find /tmp/kernel-modules/lib/modules/ -mindepth 1 -maxdepth 1)) && \
      cd /tmp/kernel-modules/lib/modules/$DVER && \
      rm build source && \
      ln -s /usr/src/linux-headers-$DVER build ) && \
    ( cd /tmp/kernel-modules && tar cf /out/kernel.tar lib ) && \
    mkdir -p /tmp/kernel-headers/usr && \
    make INSTALL_HDR_PATH=/tmp/kernel-headers/usr headers_install && \
    ( cd /tmp/kernel-headers && tar cf /out/kernel-headers.tar usr ) 

# Headers (kernel development)
RUN DVER=$(basename $(find /tmp/kernel-modules/lib/modules/ -mindepth 1 -maxdepth 1)) && \
    dir=/tmp/usr/src/linux-headers-$DVER && \
    mkdir -p $dir && \
    cp /linux/.config $dir && \
    cp /linux/Module.symvers $dir && \
    find . -path './include/*' -prune -o \
           -path './arch/*/include' -prune -o \
           -path './scripts/*' -prune -o \
           -type f \( -name 'Makefile*' -o -name 'Kconfig*' -o -name 'Kbuild*' -o \
                      -name '*.lds' -o -name '*.pl' -o -name '*.sh' \) | \
         tar cf - -T - | (cd $dir; tar xf -) && \
    ( cd /tmp && tar cf /out/kernel-dev.tar usr/src )

RUN printf "KERNEL_SOURCE=${OKERNEL_SOURCE}\n" > /kernel-source-info

# Build kernel module from linux-okernel-components
RUN if [ -n $HTTP_PROXY ]; then \
    curl -fsSL -x ${HTTP_PROXY} -o okernel-userspace.tar.gz ${USPACE_SOURCE}; \
    else \
    curl -fsSL -o okernel-userspace.tar.gz ${USPACE_SOURCE}; \
    fi

RUN cat okernel-userspace.tar.gz | tar --absolute-names -xz && mv /linux-okernel-components-master /ok_components

WORKDIR /ok_components/test_mappings/kvmod

RUN sed -i 's_~/linux-okernel_/linux_' Makefile && \
    make && \
    cp kernel_vuln.ko /out/

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=kernel-build /out/* /