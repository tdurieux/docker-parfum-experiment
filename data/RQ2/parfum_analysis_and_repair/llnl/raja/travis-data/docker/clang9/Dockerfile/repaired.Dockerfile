FROM rajaorg/compiler:ubuntu18.04-base

LABEL maintainer="Tom Scogland <scogland1@llnl.gov>"
RUN \
    sudo apt-get -qq install -y --no-install-recommends clang-9 libc++-9-dev libomp-9-dev && rm -rf /var/lib/apt/lists/*;

RUN \
    sudo apt-get -qq install -y --no-install-recommends nvidia-cuda-toolkit && rm -rf /var/lib/apt/lists/*;

USER raja
WORKDIR /home/raja
