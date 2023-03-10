FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      apt-utils \
      sudo \
      ssh \
      curl \
      ca-certificates \
      git \
      git-lfs && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sudo sh get-docker.sh && \
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && \
    curl -f -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - && \
    curl -f -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list && \
    sudo apt-get update && \
    sudo apt-get install --no-install-recommends -y nvidia-docker2 && rm -rf /var/lib/apt/lists/*;
