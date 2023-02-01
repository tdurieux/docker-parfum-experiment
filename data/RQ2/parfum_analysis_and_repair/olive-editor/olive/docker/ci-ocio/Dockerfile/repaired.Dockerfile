# Copyright (C) 2022 Olive Team
# SPDX-License-Identifier: GPL-3.0-or-later

# Build image (default):
#  docker build -t olivevideoeditor/ci-package-ocio:2022-2.1.1 -f ci-ocio/Dockerfile .

ARG OLIVE_ORG=olivevideoeditor
ARG ASWF_PKG_ORG=aswftesting
ARG CI_COMMON_VERSION=2
ARG VFXPLATFORM_VERSION=2022
# OCIO repo branch or tag name
ARG OCIO_VERSION=v2.1.1
# Latest configs ~3 GB because of ACES 1.0.x.
# Upstream only copies nuke-default, therefore we also use the older configs.