#==============================================================================
# Copyright (c) 2016-present Allan CORNET (Nelson)
#==============================================================================
# This file is part of the Nelson.
#=============================================================================
# LICENCE_BLOCK_BEGIN
# SPDX-License-Identifier: LGPL-3.0-or-later
# LICENCE_BLOCK_END
#==============================================================================

FROM fedora:35
LABEL maintainer="Allan CORNET nelson.numerical.computation@gmail.com"

ARG BRANCH_NAME
RUN echo "Nelson's branch: ${BRANCH_NAME}"

RUN dnf update -y
RUN dnf upgrade -y
RUN dnf install -y which
RUN dnf install -y hostname
RUN dnf install -y git
RUN dnf install -y make
RUN dnf install -y libtool
RUN dnf install -y gcc
RUN dnf install -y gcc-c++
RUN dnf install -y autoconf
RUN dnf install -y automake
RUN dnf install -y openmpi-devel
RUN dnf install -y gettext
RUN dnf install -y pkg-config
RUN dnf install -y cmake
RUN dnf install -y libffi-devel
RUN dnf install -y libicu-devel
RUN dnf install -y libxml2-devel
RUN dnf install -y lapack-devel
RUN dnf install -y fftw3-devel
RUN dnf install -y portaudio-devel
RUN dnf install -y libsndfile-devel
RUN dnf install -y jack-audio-connection-kit-devel
# RUN dnf install -y pipewire-jack-audio-connection-kit-devel 