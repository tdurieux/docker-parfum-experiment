# Container for building the Projecteur package
# Images available at: https://hub.docker.com/r/jahnf/projecteur/tags

FROM debian:buster

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
  ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
  g++ \
  make \
  cmake \
  udev \
  git \
  pkg-config && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
  qtdeclarative5-dev \
  qttools5-dev-tools \
  qt5-default && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
  libqt5x11extras5-dev \
  libusb-1.0-0-dev && rm -rf /var/lib/apt/lists/*;
