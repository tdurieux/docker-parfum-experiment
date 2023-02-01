# used to cache installed dependencies for bionic builds
# this speeds up builds during development, as the dependencies are just installed _once_

FROM i386/ubuntu:bionic

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y --no-install-recommends install \
        libfuse2:i386 \
        qtbase5-dev:i386 \
        qt5-qmake:i386 \
        qtbase5-dev-tools:i386 \
        libqt5core5a:i386 \
        libqt5gui5:i386 \
        libcurl4-openssl-dev:i386 \
        libssl-dev:i386 \
        libqt5widgets5:i386 \
        librsvg2-bin:i386 \
        libfuse-dev:i386 \
        libcurl4:i386 \
        libcurl4 \
        libbsd-dev:i386 \
        libglib2.0-dev:i386 \
        liblzma-dev:i386 \
        libgtest-dev \
        libcairo-dev:i386 \
        libgl1-mesa-dev:i386 \
        libglu1-mesa-dev:i386 \
        \
        rpm \
        gcc-multilib \
        g++-multilib \
        cmake \
        make \
        git \
        ca-certificates \
        automake \
        autoconf \
        libtool \
        patch \
        wget \
        vim-common \
        desktop-file-utils \
        pkg-config \
        qttools5-dev-tools:i386 \
        qt5-qmake-bin:i386 \
        libarchive-dev:i386 \
        libboost-filesystem-dev:i386
