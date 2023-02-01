FROM ubuntu:20.04

# mingw - build steps adapted from https://github.com/mmozeiko/docker-mingw-w64/blob/master/Dockerfile
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade --no-install-recommends -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        bison \
        bzip2 \
        ca-certificates \
        curl \
        file \
        flex \
        g++-10 \
        gcc-10 \
        git \
        gnupg \
        gperf \
        libgmp-dev \
        libgmp10 \
        libisl-dev \
        libisl22 \
        libmpc-dev \
        libmpc3 \
        libmpfr-dev \
        libmpfr6 \
        libssl-dev \
        libssl1.1 \
        make \
        meson \
        ninja-build \
        patch \
        python \
        python-lxml \
        python-mako \
        texinfo \
        xz-utils \
        yasm \
        zip \
        zlib1g-dev && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 1000 --slave /usr/bin/g++ g++ /usr/bin/g++-10 && rm -rf /var/lib/apt/lists/*;
ENV MINGW=/mingw
COPY mingw.sh /tmp/mingw.sh
RUN chmod +x /tmp/mingw.sh && \
    ARCH="$ARCH" LIB3264="$LIB3264" /tmp/mingw.sh
RUN apt-get remove --purge -y \
        file gcc-10 g++-10 zlib1g-dev libssl-dev libgmp-dev libmpfr-dev libmpc-dev libisl-dev python-lxml python-mako

# unprivileged user
RUN mkdir -p /code && \
    (groupadd -g $HOST_GID user || true) && \
    (useradd -r -u $HOST_UID -g $HOST_GID user || true) && \
    chown $HOST_UID:$HOST_GID /code && \
    mkdir -p /home/user && \
    chown $HOST_UID:$HOST_GID /home/user

# extra utilities
RUN apt-get install --no-install-recommends -y \
        unzip \
        xxd \
        diffutils \
        dos2unix \
        build-essential \
        libncursesw5-dev \
        libncursesw5 && rm -rf /var/lib/apt/lists/*;

# install wine if the host is x86_64, don't bother if the host is aarch64
$WINE_INSTALL

# tmbasic dependencies
COPY cmake-toolchain-win-$ARCH.cmake /tmp/
COPY libclipboard-CMakeLists.txt.diff /tmp/
COPY deps.mk /tmp/deps.mk
COPY deps.tar /tmp/
RUN mkdir -p /tmp/downloads && \
    tar xf /tmp/deps.tar -C /tmp/downloads && \
    mkdir -p /tmp/deps && \
    cd /tmp/deps && \
    export NATIVE_PREFIX=/usr \
    export TARGET_PREFIX=/usr/$ARCH-w64-mingw32 \
    export ARCH=$ARCH \
    export TARGET_OS=win \
    export TARGET_CC=$ARCH-w64-mingw32-gcc \
    export TARGET_AR=$ARCH-w64-mingw32-ar \
    export DOWNLOAD_DIR=/tmp/downloads && \
    make -j$(nproc) -f /tmp/deps.mk && \
    rm -rf /tmp/deps /tmp/deps.mk && rm /tmp/deps.tar

# environment
RUN echo "export ARCH=\"$ARCH\"" >> /etc/profile.d/tmbasic.sh && \
    echo "export IMAGE_NAME=\"$IMAGE_NAME\"" >> /etc/profile.d/tmbasic.sh && \
    echo "export PS1=\"[$IMAGE_NAME] \w\$ \"" >> /etc/profile.d/tmbasic.sh && \
    echo "export MAKEFLAGS=\"-j$(nproc)\"" >> /etc/profile.d/tmbasic.sh && \
    echo "export TARGET_OS=win" >> /etc/profile.d/tmbasic.sh && \
    echo "make -f /code/Makefile help" >> /etc/profile.d/tmbasic.sh && \
    chmod +x /etc/profile.d/tmbasic.sh

USER $HOST_UID
ENTRYPOINT ["/bin/bash", "-l"]
