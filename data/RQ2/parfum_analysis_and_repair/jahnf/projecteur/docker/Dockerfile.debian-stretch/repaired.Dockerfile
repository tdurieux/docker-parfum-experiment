# Container for building the Projecteur package
# Images available at: https://hub.docker.com/r/jahnf/projecteur/tags

FROM debian:stretch

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

RUN apt-get install -y --no-install-recommends \
  libqt5x11extras5-dev \
  libusb-1.0-0-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
  wget && rm -rf /var/lib/apt/lists/*;

# Install newer CMake version,
# otherwise the package version in the debian package
# created by the dist-package target will not be correct
RUN wget https://github.com/Kitware/CMake/releases/download/v3.19.6/cmake-3.19.6-Linux-x86_64.sh && \
  chmod +x cmake-3.19.6-Linux-x86_64.sh && \
  ./cmake-3.19.6-Linux-x86_64.sh --skip-license --prefix=/usr && \
  rm ./cmake-3.19.6-Linux-x86_64.sh
