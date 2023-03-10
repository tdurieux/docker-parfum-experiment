# this file is used to build the image gpsbabel_build_environment used by travis.

FROM ubuntu:bionic

LABEL maintainer="https://github.com/tsteven4"

WORKDIR /app

# update environment.
# bionic needs a newer git than provided by ubuntu:bionic
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    software-properties-common \
 && apt-get upgrade -y \
 && add-apt-repository ppa:git-core/ppa \
 && rm -rf /var/lib/apt/lists/*

# install packages needed for gpsbabel build
# split into multiple commands to limit layer size

# basic build and test tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    g++ \
    make \
    autoconf \
    git \
    valgrind \
    expat \
    libxml2-utils \
    bear \
    cmake \
    ninja-build \
 && rm -rf /var/lib/apt/lists/*

# alternative compiler
RUN apt-get update && apt-get install -y --no-install-recommends \
    clang \
 && rm -rf /var/lib/apt/lists/*

# pkgs needed to build document
RUN apt-get update && apt-get install -y --no-install-recommends \
    fop \
    xsltproc \
    docbook-xml \
    docbook-xsl \
 && rm -rf /var/lib/apt/lists/*

# pkgs with libraries needed by gpsbabel
RUN apt-get update && apt-get install -y --no-install-recommends \
    libusb-1.0-0-dev \
    pkg-config \
    libudev-dev \
 && rm -rf /var/lib/apt/lists/*

# pkgs with qt used by gpsbabel
RUN apt-get update && apt-get install -y --no-install-recommends \
    qt5-default \
    qttools5-dev-tools \
    qttranslations5-l10n \
    qtwebengine5-dev \
 && rm -rf /var/lib/apt/lists/*

# pkgs needed to generate coverage report:
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcovr \
 && rm -rf /var/lib/apt/lists/*

# install environment for locale test