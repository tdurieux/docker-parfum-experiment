FROM alpine:3.14
RUN set -eux \
 && apk --no-cache add \
    bash
SHELL ["/usr/bin/env", "bash", "-c"]
RUN set -eux \
 && apk --no-cache add \
    autoconf \
    automake \
    bc \
    binutils \
    build-base \
    ca-certificates \
    ccache \
    cmake \
    coreutils \
    cpio \
    curl \
    findutils \
    git \
    libtool \
    lz4 \
    mercurial \
    musl-dev \
    musl-libintl \
    ncurses-dev \
    ninja \
    python3 \
    rpcgen \
    rsync \
    sed \
    subversion \
    tar \
    unzip \
    wget \
    xz \
    zstd

ENV DAPPER_SOURCE /source
ENV DAPPER_OUTPUT ./artifacts ./dist
ENV DAPPER_ENV BUILDARCH BUILDROOT_VERSION VERBOSE
ENV DAPPER_RUN_ARGS -v k3s-root-cache:/var/cache/dl --security-opt seccomp=unconfined
ENV BR2_DL_DIR /var/cache/dl
# Required to build as root, even in Docker
ENV FORCE_UNSAFE_CONFIGURE 1
ENV HOME ${DAPPER_SOURCE}
WORKDIR ${DAPPER_SOURCE}

ENTRYPOINT ["./scripts/entry"]
CMD ["ci"]