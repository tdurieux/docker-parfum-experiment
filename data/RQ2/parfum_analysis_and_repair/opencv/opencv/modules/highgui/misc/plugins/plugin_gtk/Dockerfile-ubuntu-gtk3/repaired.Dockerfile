ARG VER
FROM ubuntu:$VER

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    pkg-config \
    cmake \
    g++ \
    ninja-build \
  && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libgtk-3-dev \
  && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /tmp