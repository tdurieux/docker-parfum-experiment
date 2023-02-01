# SPDX-License-Identifier: GPL-2.0-or-later
#
# Copyright (C) 2020 Olliver Schinagl <oliver@schinagl.nl>
# Copyright (C) 2021-2022 Cisco Systems, Inc. and/or its affiliates. All rights reserved.

# hadolint ignore=DL3007  latest is the latest stable for alpine
FROM index.docker.io/library/alpine:latest AS builder

WORKDIR /src

COPY . /src/

# hadolint ignore=DL3008  We want the latest stable versions