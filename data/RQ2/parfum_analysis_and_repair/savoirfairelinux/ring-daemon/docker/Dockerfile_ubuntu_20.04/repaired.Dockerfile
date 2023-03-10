FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository universe && \
    apt-get update && \
    apt-get install --no-install-recommends -y -o Acquire::Retries=10 \
        g++ \
        gcc \
        cpp \
        file \
        make \
        libc6-dev \
        libstdc++-8-dev \
        git \
        autoconf \
        automake \
        autopoint \
        cmake \
        dpkg-dev \
        libdbus-1-dev \
        libdbus-c++-dev \
        libupnp-dev \
        libgnutls28-dev \
        libargon2-dev \
        libcanberra-gtk3-dev \
        libclutter-gtk-1.0-dev \
        libclutter-1.0-dev \
        libglib2.0-dev \
        libgtk-3-dev \
        libnotify-dev \
        qtbase5-dev \
        qttools5-dev \
        qttools5-dev-tools \
        yasm \
        nasm \
        autotools-dev \
        libtool \
        gettext \
        libpulse-dev \
        libasound2-dev \
        libpcre3-dev \
        libyaml-cpp-dev \
        libboost-dev \
        libxext-dev \
        libxfixes-dev \
        libspeex-dev \
        libspeexdsp-dev \
        uuid-dev \
        libavcodec-dev \
        libavutil-dev \
        libavformat-dev \
        libswscale-dev \
        libavdevice-dev \
        libopus-dev \
        libudev-dev \
        libjsoncpp-dev \
        libmsgpack-dev \
        libnatpmp-dev \
        libayatana-appindicator3-dev \
        libqrencode-dev \
        libnm-dev \
        libwebkit2gtk-4.0-dev \
        libcrypto++-dev \
        libva-dev \
        libvdpau-dev \
        libssl-dev \
        libsndfile1-dev \
        libsecp256k1-dev \
        libasio-dev \
        libexpat1 libexpat1-dev \
        lcov gcovr \
        ninja-build && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python3 python3-pip python3-setuptools \
                       python3-wheel && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir meson

RUN ls -la /usr/include/c++/8/charconv

# Tests framework
RUN apt-get install --no-install-recommends -y -o Acquire::Retries=10 \
        libcppunit-dev \
        sip-tester && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean

