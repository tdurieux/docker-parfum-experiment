FROM python:2.7

MAINTAINER Qin Han "qinhan@xingshulin.com"

RUN apt-get update \
  && apt-get install --no-install-recommends -y gcc g++ cmake curl unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir numpy

COPY ./scripts/install-opencv-linux.sh ./install-opencv-linux.sh

RUN sh install-opencv-linux.sh
