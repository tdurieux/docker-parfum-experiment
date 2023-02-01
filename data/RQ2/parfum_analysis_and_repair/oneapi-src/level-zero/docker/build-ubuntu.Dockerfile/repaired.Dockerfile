# Copyright (C) 2020 Intel Corporation
# SPDX-License-Identifier: MIT

ARG IMAGE_VERSION=eoan-20200114
FROM ubuntu:$IMAGE_VERSION

RUN apt-get update && apt-get install --no-install-recommends -y \
        build-essential \
        ccache \
        cmake \
        file \
        git \
        ninja-build \
    && rm -rf /var/lib/apt/lists/*
