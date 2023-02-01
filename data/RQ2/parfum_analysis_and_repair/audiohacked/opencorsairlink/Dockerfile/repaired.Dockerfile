FROM ubuntu:18.04

ARG BRANCH=testing

LABEL maintainer="zaggash"

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    git \
    libusb-1.0 \
    pkg-config && rm -rf /var/lib/apt/lists/*;

RUN \
  git clone -b ${BRANCH} https://github.com/audiohacked/OpenCorsairLink.git /OpenCorsairLink && \
  cd /OpenCorsairLink && \
  make

WORKDIR /OpenCorsairLink
ENTRYPOINT cp OpenCorsairLink.elf /opt
