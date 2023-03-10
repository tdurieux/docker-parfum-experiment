FROM ubuntu:latest
RUN mkdir /work
WORKDIR /work
RUN \
  apt update && \
  apt install -y --no-install-recommends clang ssh git tar zip ca-certificates software-properties-common && \
  apt install --no-install-recommends -y cmake python-pip python3-pip && \
  add-apt-repository -y ppa:deadsnakes/ppa && \
  apt install --no-install-recommends -y python3.4 python3.4-dev python3.5 python3.5-dev python3.6 python3.6-dev python3.7 python3.7-dev && \
  rm -rf /var/lib/apt/lists/*
