# xArch Diana-Plus Image
# Derek Merck, Winter 2019

ARG DOCKER_ARCH="amd64"
# ARG DOCKER_ARCH="arm32v7"
# ARG DOCKER_ARCH="arm64v8"

FROM derekmerck/diana2-plus-base:latest-${DOCKER_ARCH}

LABEL description="X-Arch Diana-Plus"

RUN mkdir /opt/diana
WORKDIR /opt/diana

RUN git clone https://github.com/derekmerck/diana2 /opt/diana \
 && pip3 install --no-cache-dir -e /opt/diana/package[plus]

