FROM debian:bullseye-slim

LABEL author="Everton Haise Taques <everton.taques@encora.com>"
LABEL maintainer="NS1 Labs"
LABEL version="1.0.0"

ENV BUILD_DEPS "g++ cmake make git pkgconf jq python3-pip python3-setuptools ca-certificates libasan6 zip curl"

COPY ./entrypoint.sh /entrypoint.sh

RUN mkdir -p /pktvisor-src

WORKDIR /pktvisor-src

RUN apt-get update && \
    apt-get upgrade --yes --force-yes && \
    apt-get install --yes --force-yes --no-install-recommends ${BUILD_DEPS} && \
    pip3 install conan

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

