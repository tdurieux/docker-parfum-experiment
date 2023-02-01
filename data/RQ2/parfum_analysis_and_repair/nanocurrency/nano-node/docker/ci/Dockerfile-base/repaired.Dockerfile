FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install --no-install-recommends -yqq \
build-essential \
g++ \
wget \
python \
zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN wget -O cmake_install.sh https://github.com/Kitware/CMake/releases/download/v3.15.4/cmake-3.15.4-Linux-x86_64.sh && \
chmod +x cmake_install.sh && \
./cmake_install.sh --prefix=/usr --exclude-subdir --skip-license

RUN apt-get update -qq && apt-get install --no-install-recommends -yqq \
qt5-default \
valgrind \
xorg xvfb xauth xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic && rm -rf /var/lib/apt/lists/*;

ARG REPOSITORY=nanocurrency/nano-node
LABEL org.opencontainers.image.source https://github.com/$REPOSITORY
