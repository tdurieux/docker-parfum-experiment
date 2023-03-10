# Create DIAMBRA Arena base image (diambra:diambra-arena-base)
ARG BASE_IMAGE=ubuntu:20.04
FROM $BASE_IMAGE

ARG BOOST_VERSION=1.71.0

# Maintainer
LABEL maintainer="DIAMBRA Team <info@diambra.ai>"

RUN printf 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";\n' > /etc/apt/apt.conf.d/99norecommend && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -qy install -qy gnupg2 curl wget ca-certificates build-essential \
      libfreetype6-dev libhdf5-serial-dev libzmq3-dev pkg-config software-properties-common unzip \
      python3-pip python3-tk python3-setuptools libopencv-dev libboost-filesystem${BOOST_VERSION} xvfb \
      libsdl2-2.0-0 libsdl2-ttf-2.0-0 libqt5core5a libqt5widgets5 libqt5gui5 lshw && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* && \
      ln -s python3 /usr/bin/python && \
      ln -sf pip3 /usr/bin/pip && \
      pip install --no-cache-dir --upgrade pip
