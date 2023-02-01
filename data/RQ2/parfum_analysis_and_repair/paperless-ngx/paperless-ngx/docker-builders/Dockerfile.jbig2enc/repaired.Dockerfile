# This Dockerfile compiles the jbig2enc library
# Inputs:
#    - JBIG2ENC_VERSION - the Git tag to checkout and build

FROM debian:bullseye-slim as main

LABEL org.opencontainers.image.description="A intermediate image with jbig2enc built"

ARG DEBIAN_FRONTEND=noninteractive

ARG BUILD_PACKAGES="\
  build-essential \
  automake \
  libtool \
  libleptonica-dev \
  zlib1g-dev \
  git \
  ca-certificates"

WORKDIR /usr/src/jbig2enc

# As this is an base image for a multi-stage final image
# the added size of the install is basically irrelevant
RUN apt-get update --quiet \
  && apt-get install --yes --quiet --no-install-recommends ${BUILD_PACKAGES} \
  && rm -rf /var/lib/apt/lists/*

# Layers after this point change according to required version
# For better caching, seperate the basic installs from
# the building

ARG JBIG2ENC_VERSION

RUN set -eux \
  && git clone --quiet --branch $JBIG2ENC_VERSION https://github.com/agl/jbig2enc .
RUN set -eux \
  && ./autogen.sh
RUN set -eux \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make
