# Freeze base image version to
# ubuntu:20.04 (pushed 2022-04-05T22:38:34.466804Z)
# https://hub.docker.com/layers/ubuntu/library/ubuntu/20.04/images/sha256-31cd7bbfd36421dfd338bceb36d803b3663c1bfa87dfe6af7ba764b5bf34de05
FROM ubuntu@sha256:31cd7bbfd36421dfd338bceb36d803b3663c1bfa87dfe6af7ba764b5bf34de05 as base

SHELL ["bash", "-euxo", "pipefail", "-c"]

RUN set -euxo pipefail >/dev/null \
&& export DEBIAN_FRONTEND=noninteractive \
&& apt-get update -qq --yes \
&& apt-get install -qq --no-install-recommends --yes \
  bash \
  bzip2 \
  ca-certificates \
  cmake \
  cpio \
  curl \
  git \
  gnupg\
  gzip \
  libbz2-dev \
  libssl-dev \
  libxml2-dev \
  lsb-release \
  make \
  patch \
  sed \
  tar \
  uuid-dev \
  xz-utils \
  zlib1g-dev \
>/dev/null \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean autoclean >/dev/null \
&& apt-get autoremove --yes >/dev/null


# Install LLVM/Clang (https://apt.llvm.org/)