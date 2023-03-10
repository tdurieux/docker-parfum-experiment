FROM debian:bullseye

RUN dpkg --add-architecture armhf

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 python3-pip python3-setuptools python3-wheel \
                    ninja-build crossbuild-essential-armhf bison flex \
                    g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf pkg-config software-properties-common \
                    libdrm-dev:armhf libx11-dev:armhf libxext-dev:armhf libxcb-glx0-dev:armhf libx11-xcb-dev:armhf \
                    libxcb-dri2-0-dev:armhf libxcb-dri3-dev:armhf libxcb-present-dev:armhf \
                    libxshmfence-dev:armhf libxxf86vm-dev:armhf libxrandr-dev:armhf \
                    libxdamage-dev:armhf zlib1g-dev:armhf && \
    apt-get autoclean && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir mako meson

