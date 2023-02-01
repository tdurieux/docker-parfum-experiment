# syntax = docker/dockerfile:experimental
# Copyright (c) Contributors to the aswf-docker Project. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

# "Global" ARGs
ARG ASWF_ORG
ARG CI_COMMON_VERSION
ARG ASWF_CMAKE_VERSION
ARG ASWF_CLANG_MAJOR_VERSION
ARG ASWF_PYTHON_VERSION
ARG ASWF_PYTHON_MAJOR_MINOR_VERSION
ARG ASWF_QT_VERSION
ARG ASWF_VFXPLATFORM_VERSION

# Required base packages built in previous stages
FROM ${ASWF_ORG}/ci-package-cmake:${ASWF_VFXPLATFORM_VERSION}-${ASWF_CMAKE_VERSION} as ci-package-cmake-external


#################### ci-centos7-gl-packages ####################
FROM ${ASWF_ORG}/ci-common:${CI_COMMON_VERSION}-clang${ASWF_CLANG_MAJOR_VERSION} as ci-centos7-gl-packages

COPY --from=ci-package-cmake-external /. /usr/local/

COPY ../scripts/common/before_build.sh \
     ../scripts/common/copy_new_files.sh \
     /tmp/

ENV DOWNLOADS_DIR=/tmp/downloads \
    CCACHE_DIR=/tmp/ccache \
    ASWF_INSTALL_PREFIX=/usr/local


#################### ci-qt-builder ####################
FROM ci-centos7-gl-packages as ci-qt-builder

ARG ASWF_QT_VERSION
ENV ASWF_QT_VERSION=${ASWF_QT_VERSION}

COPY ../scripts/base/build_qt.sh \
     /tmp/

RUN --mount=type=cache,target=/tmp/ccache \
    --mount=type=cache,sharing=private,target=/tmp/downloads \
    /tmp/before_build.sh && \
    /tmp/build_qt.sh && \
    /tmp/copy_new_files.sh && \
    ccache --show-stats


#################### ci-package-qt ####################