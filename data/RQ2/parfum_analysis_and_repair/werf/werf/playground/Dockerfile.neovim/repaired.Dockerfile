FROM ubuntu:20.04

ARG TIMESTAMP=overridethis

ARG BUILD_APT_DEPS="ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip git binutils"
ARG DEBIAN_FRONTEND=noninteractive
ARG TARGET=stable

RUN apt update && apt upgrade -y && \
  apt install --no-install-recommends -y ${BUILD_APT_DEPS} && \
  git clone https://github.com/neovim/neovim.git && \
  cd neovim && \
	git checkout tags/${TARGET} && \
  make CMAKE_BUILD_TYPE=Release && \
  make CMAKE_INSTALL_PREFIX=/usr/local install && \
  strip /usr/local/bin/nvim && rm -rf /var/lib/apt/lists/*;
