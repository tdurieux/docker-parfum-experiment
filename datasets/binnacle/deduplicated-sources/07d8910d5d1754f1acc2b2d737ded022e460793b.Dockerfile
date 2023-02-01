#ARG BUILD_FROM=hassioaddons/ubuntu-base-amd64:2.0.0 
ARG BUILD_FROM=debian:stretch
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Setup base system
ARG BUILD_ARCH=amd64

RUN \
    apt-get update \
    && apt-get install -y \
        bluetooth \
        bluez \
        bluez-tools \
        rfkill \
        libmosquitto-dev \
        mosquitto \
        mosquitto-clients

  
COPY rootfs /scripts
COPY run.sh /

VOLUME /app

WORKDIR /app

CMD ["bash", "/run.sh"]