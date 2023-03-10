FROM alpine:3.15

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
        bash \
        clang \
        curl \
        make \
        pkgconfig \
        xxd \
        python3 \
        cmake \
        autoconf \
        automake \
        gcc \
        g++ \
        musl-dev \
        patch \
        linux-headers \
        texinfo

# unprivileged user
RUN (addgroup -g $HOST_GID user || true) && \
    (adduser -h /home/user -s /bin/bash -g $HOST_GID -u $HOST_UID -D user || true)

# sysroot
COPY sysroot-$ARCH.tar.gz /tmp/sysroot.tar.gz
RUN mkdir /target-sysroot && \
    cd /target-sysroot && \
    tar zxf /tmp/sysroot.tar.gz && rm /tmp/sysroot.tar.gz

# tmbasic dependencies
COPY cmake-toolchain-linux-$ARCH.cmake /tmp/
COPY libclipboard-CMakeLists.txt.diff /tmp/
COPY deps.mk /tmp/
COPY deps.tar /tmp/
RUN mkdir -p /tmp/downloads && \
    tar xf /tmp/deps.tar -C /tmp/downloads && \
    mkdir -p /usr/local/$TRIPLE/include && \
    mkdir -p /tmp/deps && \
    cd /tmp/deps && \
    export NATIVE_PREFIX=/usr && \
    export TARGET_PREFIX=/usr/local/$TRIPLE && \
    export ARCH=$ARCH && \
    export LINUX_DISTRO=alpine && \
    export LINUX_TRIPLE=$TRIPLE && \
    export TARGET_OS=linux && \
    export DOWNLOAD_DIR=/tmp/downloads && \
    make -j$(nproc) -f /tmp/deps.mk && \
    rm -rf /tmp/deps /tmp/deps.mk && rm /tmp/deps.tar

# environment
RUN echo "export ARCH=\"$ARCH\"" >> /etc/profile.d/tmbasic.sh && \
    echo "export IMAGE_NAME=\"$IMAGE_NAME\"" >> /etc/profile.d/tmbasic.sh && \
    echo "export PS1=\"[$IMAGE_NAME] \w\$ \"" >> /etc/profile.d/tmbasic.sh && \
    echo "export MAKEFLAGS=\"-j$(nproc)\"" >> /etc/profile.d/tmbasic.sh && \
    echo "export TARGET_OS=linux" >> /etc/profile.d/tmbasic.sh && \
    echo "export LINUX_DISTRO=alpine" >> /etc/profile.d/tmbasic.sh && \
    echo "export LINUX_TRIPLE=$TRIPLE" >> /etc/profile.d/tmbasic.sh && \
    echo "export PREFIX=/usr/local/$TRIPLE" >> /etc/profile.d/tmbasic.sh && \
    echo "make -f /code/Makefile help" >> /etc/profile.d/tmbasic.sh && \
    chmod +x /etc/profile.d/tmbasic.sh

USER $HOST_UID
ENTRYPOINT ["/bin/bash", "-l"]
