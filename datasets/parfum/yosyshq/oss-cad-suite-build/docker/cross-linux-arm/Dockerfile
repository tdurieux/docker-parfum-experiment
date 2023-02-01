FROM yosyshq/cross-base:1.0

ENV CROSS_NAME arm-linux-gnueabihf

ENV CROSS_PREFIX /opt/${CROSS_NAME}

RUN set -e -x ;\
    apt -y update ;\
    apt -y upgrade ;\
    apt -y install \
        gcc-arm-linux-gnueabihf \
        g++-arm-linux-gnueabihf \
        gnat-9-arm-linux-gnueabihf \
        libc6-dev-armhf-cross; \
    echo 'deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ focal main multiverse restricted universe' > /etc/apt/sources.list ; \
    echo 'deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ focal main multiverse restricted universe' >> /etc/apt/sources.list ; \
    echo 'deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ focal-updates main multiverse restricted universe' >> /etc/apt/sources.list ; \
    echo 'deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ focal-security main multiverse restricted universe' >> /etc/apt/sources.list ; \
    echo 'deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ focal-updates main multiverse restricted universe' >> /etc/apt/sources.list ; \
    echo 'deb [arch=amd64] http://security.ubuntu.com/ubuntu/ focal-security main multiverse restricted universe' >> /etc/apt/sources.list ; \
    dpkg --add-architecture armhf ;\
    apt -y update ;\
    apt -y upgrade ;\
    apt -y install \
        libboost-dev:armhf \
        libboost-filesystem-dev:armhf \
        libboost-thread-dev:armhf \
        libboost-iostreams-dev:armhf \
        libboost-program-options-dev:armhf \
        libeigen3-dev:armhf \
        libffi-dev:armhf \
        libftdi1-dev:armhf \
        libgmp-dev:armhf \
        libgtk-3-dev:armhf \
        liblzma-dev:armhf \
        libreadline-dev:armhf \
        libsqlite3-dev:armhf \
        libssl-dev:armhf \
        tcl-dev:armhf \
        tk-dev:armhf \
        qtbase5-dev:armhf \
        libbison-dev:armhf \
        libhidapi-dev:armhf \
        libcurl4-openssl-dev:armhf \
        libbz2-dev:armhf \
        libllvm10:armhf \
        libltdl-dev:armhf; \
    apt -y autoremove ;\
    rm -rf /var/lib/apt/lists/*

ENV AS=/usr/bin/${CROSS_NAME}-as \
    AR=/usr/bin/${CROSS_NAME}-ar \
    CC=/usr/bin/${CROSS_NAME}-gcc \
    CPP=/usr/bin/${CROSS_NAME}-cpp \
    CXX=/usr/bin/${CROSS_NAME}-g++ \
    LD=/usr/bin/${CROSS_NAME}-ld \
    STRIP=/usr/bin/${CROSS_NAME}-strip

COPY Toolchain.cmake ${CROSS_PREFIX}/

ENV CMAKE_TOOLCHAIN_FILE ${CROSS_PREFIX}/Toolchain.cmake

ENV PKG_CONFIG_PATH /usr/lib/arm-linux-gnueabihf/pkgconfig

RUN rustup target add arm-unknown-linux-gnueabihf && \
    mkdir -p /.cargo && \
    echo "[target.arm-unknown-linux-gnueabihf]" > /.cargo/config && \
    echo "linker = \"arm-linux-gnueabihf-gcc\"" >> /.cargo/config

RUN wget http://ports.ubuntu.com/pool/main/g/gobject-introspection/libgirepository1.0-dev_1.64.1-1~ubuntu20.04.1_armhf.deb && \
    dpkg-deb -xv libgirepository1.0-dev_1.64.1-1~ubuntu20.04.1_armhf.deb / && \
    rm -rf libgirepository1.0-dev_1.64.1-1~ubuntu20.04.1_armhf.deb && \
    wget http://ports.ubuntu.com/pool/main/g/gobject-introspection/gir1.2-glib-2.0_1.64.1-1~ubuntu20.04.1_armhf.deb && \
    dpkg-deb -xv gir1.2-glib-2.0_1.64.1-1~ubuntu20.04.1_armhf.deb / && \
    rm -rf gir1.2-glib-2.0_1.64.1-1~ubuntu20.04.1_armhf.deb
