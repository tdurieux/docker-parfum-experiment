FROM debian:latest

WORKDIR /tmp

RUN apt-get update && apt-get -y upgrade && apt-get install --no-install-recommends -y \
    git \
    cmake build-essential zlib1g-dev \
    libcfitsio-dev libnova-dev libusb-1.0-0-dev libcurl4-gnutls-dev \
    libgsl-dev libjpeg-dev libfftw3-dev libev-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/google/googletest.git googletest && \
    cd googletest && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_SHARED_LIBS=ON . && \
    make && \
    make install && \
    rm -rf /tmp/googletest

# INDI 3rd Party
RUN apt-get install --no-install-recommends -y \
    libftdi1-dev libavcodec-dev libavdevice-dev libavformat-dev libswscale-dev \
    libgps-dev libraw-dev libdc1394-22-dev libgphoto2-dev \
    libboost-dev libboost-regex-dev librtlsdr-dev liblimesuite-dev && rm -rf /var/lib/apt/lists/*;
