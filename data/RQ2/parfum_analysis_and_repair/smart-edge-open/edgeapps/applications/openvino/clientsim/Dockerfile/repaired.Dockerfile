# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM ubuntu:20.04

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy,openvino.openness
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get update && \
       apt-get -y --no-install-recommends install build-essential gcc g++ cmake && \
       apt-get -y --no-install-recommends install cpio && \
       apt-get -y --no-install-recommends install sudo && \
       apt-get -y --no-install-recommends install unzip && \
       apt-get -y --no-install-recommends install wget && \
       apt-get -y --no-install-recommends install curl && \
       apt-get -y --no-install-recommends install lsb-core && \
       apt-get -y --no-install-recommends install autoconf libtool && \
       apt-get -y --no-install-recommends install ffmpeg x264 && \
       rm -rf /var/lib/apt/lists/*

RUN ln -snf /usr/share/zoneinfo/$( curl -f https://ipapi.co/timezone -k) /etc/localtime

RUN wget  --no-check-certificate https://storage.googleapis.com/coverr-main/zip/Rainy_Street.zip
RUN unzip Rainy_Street.zip

COPY tx_video.sh .
COPY start.sh .
ENTRYPOINT ["./start.sh"]
