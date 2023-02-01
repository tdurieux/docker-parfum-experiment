# Debian Stretch.
FROM debian@sha256:cebe6e1c30384958d471467e231f740e8f0fd92cbfd2a435a186e9bada3aee1c
MAINTAINER Gregory Szorc <gregory.szorc@gmail.com>

RUN groupadd -g 1000 build && \
    useradd -u 1000 -g 1000 -d /build -s /bin/bash -m build && \
    mkdir /tools && \
    chown -R build:build /build /tools

ENV HOME=/build \
    SHELL=/bin/bash \
    USER=build \
    LOGNAME=build \
    HOSTNAME=builder \
    DEBIAN_FRONTEND=noninteractive

CMD ["/bin/bash", "--login"]
WORKDIR '/build'

RUN for s in debian_stretch debian_stretch-updates debian-security_stretch/updates; do \
      echo "deb http://snapshot.debian.org/archive/${s%_*}/20220429T205342Z/ ${s#*_} main"; \
    done > /etc/apt/sources.list && \
    ( echo 'quiet "true";'; \
      echo 'APT::Get::Assume-Yes "true";'; \
      echo 'APT::Install-Recommends "false";'; \
      echo 'Acquire::Check-Valid-Until "false";'; \
      echo 'Acquire::Retries "5";'; \
    ) > /etc/apt/apt.conf.d/99cpython-portable

RUN apt-get update

# Host building.
RUN apt-get install -y --no-install-recommends \
    bzip2 \
    gcc \
    g++ \
    libc6-dev \
    libffi-dev \
    make \
    patch \
    perl \
    pkg-config \
    tar \
    xz-utils \
    unzip \
    zip \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# Cross-building.
RUN apt-get install -y --no-install-recommends \
    gcc-aarch64-linux-gnu \
    gcc-arm-linux-gnueabi \
    gcc-arm-linux-gnueabihf \
    gcc-mips-linux-gnu \
    gcc-mips64el-linux-gnuabi64 \
    gcc-mipsel-linux-gnu \
    gcc-s390x-linux-gnu \
    libc6-dev-arm64-cross \
    libc6-dev-armel-cross \
    libc6-dev-armhf-cross \
    libc6-dev-mips-cross \
    libc6-dev-mips64el-cross \
    libc6-dev-mipsel-cross \
    libc6-dev-s390x-cross && rm -rf /var/lib/apt/lists/*;
