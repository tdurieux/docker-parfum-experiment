FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      build-essential \
      clang \
      cmake \
      curl \
      git \
      jq \
      libtool \
      python3 \
      sudo \
      vim \
      wget \
      zlib1g-dev && rm -rf /var/lib/apt/lists/*;