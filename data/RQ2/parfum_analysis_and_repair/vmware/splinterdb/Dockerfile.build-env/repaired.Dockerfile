# Copyright 2018-2021 VMware, Inc.
# SPDX-License-Identifier: Apache-2.0

# Source for the image
#    projects.registry.vmware.com/splinterdb/build-env
#
# This contains the build-time dependencies for SplinterDB.
#
# To build this image locally:
# $ docker build -t build-env - < Dockerfile.build-env
# To then build SplinterDB itself from souce:
# $ docker run -it --rm --mount type=bind,source="$PWD",target=/splinterdb build-env /bin/bash
#
# This file is maintained separately from the other Dockerfiles
# to reduce build times when the SplinterDB source changes

ARG base_image=library/ubuntu:20.04
FROM $base_image

# Install stuff required to install appropriate compiler versions.
RUN /bin/bash -c ' \
set -euo pipefail; \
export DEBIAN_FRONTEND=noninteractive; \
apt-get update -y && apt-get install -y software-properties-common wget'

# Install llvm and clang v13 for Ubuntu 20.04 and make them the default
# We rely on clang-format-13 for ./format-check.sh
RUN /bin/bash -c ' \
set -euo pipefail; \
export DEBIAN_FRONTEND=noninteractive; \
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    && add-apt-repository "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-13 main" \
    && apt-get install -y clang-13 clang-format-13 lld-13 \
    && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-13 1 \
    && update-alternatives --install /usr/bin/lld lld /usr/bin/lld-13 1 \
    && update-alternatives --install /usr/bin/ld.lld ld.lld /usr/bin/ld.lld-13 1'

# Install remaining tools required for builds
RUN /bin/bash -c ' \
set -euo pipefail; \
export DEBIAN_FRONTEND=noninteractive; \
apt-get install -y make libaio-dev libconfig-dev libxxhash-dev gcc curl git shellcheck yamllint;'

# shell formatter