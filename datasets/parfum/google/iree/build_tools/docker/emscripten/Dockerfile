# Copyright 2021 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# An image for building IREE through Emscripten.

FROM gcr.io/iree-oss/base@sha256:9d742e01507c292def852cbfebfae71412cff94df0ab2619f61f9a5a2a98f651

# See also
#   * https://github.com/emscripten-core/emsdk/blob/main/docker/Dockerfile
#   * https://hub.docker.com/r/emscripten/emsdk

ARG EMSDK_COMMIT=62d817b66dad481b150fd49cdc1e803725d23813
ARG SDK_VERSION=3.1.12

WORKDIR /

# Follow https://emscripten.org/docs/getting_started/downloads.html.
RUN git clone https://github.com/emscripten-core/emsdk \
    && cd emsdk && git checkout "${EMSDK_COMMIT?}" && \
    ./emsdk install ${SDK_VERSION?} && \
    ./emsdk activate ${SDK_VERSION?}

# Set some environment variables for Emscripten to use.
ENV EMSDK=/emsdk
ENV EM_DATA=${EMSDK}/.data
ENV EM_CONFIG=${EMSDK}/.emscripten
ENV EM_CACHE=${EM_DATA}/cache
ENV EM_PORTS=${EM_DATA}/ports
# Emscripten writes into its cache location (outside of the CMake build
# directory).
# We can either
#   (A) Grant broad write permissions to the cache directory to be able to run
#       our scripts under different users.
#   (B) Mount a user home directory when using the image.
# Since (A) requires less configuration, we'll do that. If multiple tools would
# want a user directory (like Bazel), we should switch to (B).
# See https://github.com/emscripten-core/emsdk/issues/535
RUN mkdir -p "${EM_CACHE?}" && chmod -R 777 "${EM_CACHE?}"

# Normally we'd run `source emsdk_env.sh`, but that doesn't integrate with
# Docker's environment properties model. Instead, we directly extend the path
# to include the directories suggested by `emsdk activate`.
ENV PATH="${EMSDK?}:${EMSDK?}/node/14.15.5_64bit/bin:${EMSDK?}/upstream/emscripten:$PATH"
