FROM debian:9

# NOTE: This is mostly a copy of https://gitlab.com/nvidia/container-toolkit/libnvidia-container/-/blob/master/mk/Dockerfile.debian
ENV DEBIAN_FRONTEND=noninteractive
# NOTE(jkoelker) Ignore "Pin versions in apt get install.
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        bmake \
        build-essential \
        bzip2 \
        ca-certificates \
        curl \
        devscripts \
        dh-make \
        fakeroot \
        git \
        gnupg2 \
        libcap-dev \
        libelf-dev \
        libseccomp-dev \
        lintian \
        lsb-release \
        m4 \
        pkg-config \
        xz-utils && \
    rm -rf /var/lib/apt/lists/*

ENV GPG_TTY /dev/console

WORKDIR /tmp/libnvidia-container
COPY . .

ARG WITH_LIBELF=no
ARG WITH_TIRPC=no
ARG WITH_SECCOMP=yes
ENV WITH_LIBELF=${WITH_LIBELF}
ENV WITH_TIRPC=${WITH_TIRPC}
ENV WITH_SECCOMP=${WITH_SECCOMP}

CMD ["bash"]