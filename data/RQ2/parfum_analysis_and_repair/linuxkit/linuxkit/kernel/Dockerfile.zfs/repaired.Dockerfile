ARG IMAGE
ARG BUILD_IMAGE

FROM ${IMAGE} AS ksrc

FROM ${BUILD_IMAGE} AS build
RUN apk add --no-cache \
    attr-dev \
    autoconf \
    automake \
    build-base \
    file \
    git \
    libtirpc-dev \
    libtool \
    mpc1-dev \
    mpfr-dev \
    openssl-dev \
    util-linux-dev \
    zlib-dev

COPY --from=ksrc /kernel-dev.tar /
RUN tar xf kernel-dev.tar && rm kernel-dev.tar

# Also extract the kernel modules
COPY --from=ksrc /kernel.tar /
RUN tar xf kernel.tar && rm kernel.tar

# SPL is part of the ZFS repo since 0.8.0 (https://github.com/zfsonlinux/zfs/releases/tag/zfs-0.8.0)
ENV VERSION=0.8.1

ENV ZFS_REPO=https://github.com/zfsonlinux/zfs.git
ENV ZFS_COMMIT=zfs-${VERSION}
RUN git clone ${ZFS_REPO} && \
    cd zfs && \
    git checkout ${ZFS_COMMIT}

WORKDIR /zfs
RUN ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    ./scripts/make_gitrev.sh && \
    cd module && \
    make -j "$(getconf _NPROCESSORS_ONLN)" && \
    make install

# Run depmod against the new module directory.
RUN cd /lib/modules && \
    depmod -ae *

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=build /lib/modules/ /lib/modules/
