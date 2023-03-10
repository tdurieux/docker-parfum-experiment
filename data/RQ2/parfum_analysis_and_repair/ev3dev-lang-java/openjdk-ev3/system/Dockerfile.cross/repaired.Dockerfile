ARG DEBIAN_RELEASE=stretch
ARG ARCH=armel
FROM debian:$DEBIAN_RELEASE
ARG DEBIAN_RELEASE
ARG ARCH

# this is a customized version of ev3dev-stretch-cross image

# setup repositories and install required packages
COPY sources.list.$DEBIAN_RELEASE /etc/apt/sources.list
COPY ev3dev-archive-keyring.gpg /etc/apt/trusted.gpg.d/
RUN dpkg --add-architecture $ARCH && \
    apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install --yes --no-install-recommends \
        bash-completion \
        ca-certificates \
        cmake \
        build-essential \
        crossbuild-essential-$ARCH \
        gdb-multiarch \
        less \
        man-db \
        nano \
        pkg-config \
        qemu-user-static \
        sudo \
        tree \
        vim \
        wget \
        xz-utils \
        libcups2-dev:$ARCH       \
        libfreetype6-dev:$ARCH   \
        libfontconfig1-dev:$ARCH \
        libasound2-dev:$ARCH     \
        libx11-dev:$ARCH         \
        libxext-dev:$ARCH        \
        libxrender-dev:$ARCH     \
        libxrandr-dev:$ARCH      \
        libxtst-dev:$ARCH        \
        libxt-dev:$ARCH          \
        libffi-dev:$ARCH         \
        libpng-dev:$ARCH         \
        libjpeg-dev:$ARCH        \
        libgif-dev:$ARCH         \
        liblcms2-dev:$ARCH       \
        zlib1g-dev:$ARCH         \
        systemtap                \
        systemtap-sdt-dev        \
        curl \
        make \
        m4 \
        cpio \
        gawk \
        file \
        zip \
        pigz \
        unzip \
        procps \
        autoconf \
        autoconf-archive \
        automake \
        autotools-dev \
        mercurial \
        git \
        zlib1g-dev && \
    (if [ "$DEBIAN_RELEASE" = "stretch" ]; then \
        wget https://ftp.debian.org/debian/pool/main/s/systemtap/systemtap-sdt-dev_3.1-2_$ARCH.deb -O /tmp/systemtap.deb; \
      elif [ "$DEBIAN_RELEASE" = "buster" ]; then \
        wget https://ftp.debian.org/debian/pool/main/s/systemtap/systemtap-sdt-dev_4.0-1_$ARCH.deb -O /tmp/systemtap.deb; \
      fi) && \
    dpkg-deb -x /tmp/systemtap.deb / && \
    rm -rf /tmp/systemtap.deb /var/lib/apt/lists/*

# prepare a nonroot user
COPY compiler.sudoers /etc/sudoers.d/compiler
RUN chmod 0440 /etc/sudoers.d/compiler && \
    adduser --disabled-password --gecos \"\" compiler && \
    usermod -a -G sudo compiler
