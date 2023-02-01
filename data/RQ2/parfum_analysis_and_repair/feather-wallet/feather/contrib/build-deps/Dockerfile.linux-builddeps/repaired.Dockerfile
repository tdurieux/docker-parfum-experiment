FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /deps

RUN sed -i '/bionic-backports/d' /etc/apt/sources.list

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget xz-utils nano gpg xz-utils ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY get-packages.sh .
RUN bash get-packages.sh

RUN apt-get install -y --no-install-recommends --no-install-suggests --reinstall --download-only \

    software-properties-common python3 build-essential automake libtool-bin git \

    unzip \

    libjpeg-dev libvpx-dev libvorbis-dev \

    autopoint gettext gperf libpng-dev \

    bison \


    libx11-dev \
    libx11-xcb-dev \
    libxext-dev \
    libxfixes-dev \
    libxi-dev \
    libxrender-dev \
    libxcb1-dev \
    libxcb-keysyms1-dev \
    libxcb-image0-dev \
    libxcb-icccm4-dev \
    libxcb-xfixes0-dev \
    libxcb-render-util0-dev \
    libxcb-xinerama0-dev \
    libxcb-randr0-dev \
    libxcb-sync-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    xutils-dev \
    libxcb-util-dev \
    libxcb-xinput-dev \


    libudev1 libudev-dev \

    gstreamer1.0-plugins-good \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \

    libpsl5 && rm -rf /var/lib/apt/lists/*;

# Verify packages
RUN ln -s /var/cache/apt/archives /archives
COPY verify-packages.sh .
RUN bash verify-packages.sh