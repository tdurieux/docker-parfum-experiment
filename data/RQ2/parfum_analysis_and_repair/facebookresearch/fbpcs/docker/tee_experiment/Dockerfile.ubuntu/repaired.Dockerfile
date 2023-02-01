# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
ARG os_release="latest"
ARG fbpcf_image="fbpcf/ubuntu:latest"

FROM ${fbpcf_image} as dev

RUN mkdir -p /root/build/tee_pl
WORKDIR /root/build/tee_pl

# cmake files