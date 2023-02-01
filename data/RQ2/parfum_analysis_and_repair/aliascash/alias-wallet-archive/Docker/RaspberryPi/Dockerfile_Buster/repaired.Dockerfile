# SPDX-FileCopyrightText: © 2020 Alias Developers
# SPDX-FileCopyrightText: © 2016 SpectreCoin Developers
#
# SPDX-License-Identifier: MIT

### At first perform source build ###
FROM aliascash/alias-wallet-builder-raspi-buster:2.4 as build
MAINTAINER HLXEasy <hlxeasy@gmail.com>

# Build parameters
ARG BUILD_THREADS="6"

# Runtime parameters
ENV BUILD_THREADS=$BUILD_THREADS

COPY . /alias-wallet

RUN cd /alias-wallet \
 && ./scripts/cmake-build.sh -g -o -s -c ${BUILD_THREADS} \
 && strip /alias-wallet/cmake-build-cmdline/aliaswallet/src/aliaswalletd \
 && strip /alias-wallet/cmake-build-cmdline/aliaswallet/src/aliaswallet

### Now upload binaries to GitHub ###
FROM aliascash/github-uploader:latest
MAINTAINER HLXEasy <hlxeasy@gmail.com>

ARG GITHUB_CI_TOKEN=1234567
ARG ALIAS_RELEASE=latest
ARG ALIAS_REPOSITORY=alias-wallet
ARG GIT_COMMIT=unknown
ARG REPLACE_EXISTING_ARCHIVE=''
#ENV GITHUB_CI_TOKEN=${GITHUB_CI_TOKEN}