# Copyright (C) 2020 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM ubuntu:20.04

LABEL maintainer="HE Toolkit https://github.com/intel/he-toolkit"

# Proxies, user configured
ARG http_proxy
ARG https_proxy
ARG socks_proxy
ARG ftp_proxy
ARG no_proxy

ARG TZ=UTC
ARG DEBIAN_FRONTEND=noninteractive

ENV http_proxy=$http_proxy   \
    https_proxy=$https_proxy \
    socks_proxy=$socks_proxy \
    ftp_proxy=$ftp_proxy     \
    no_proxy=$no_proxy

RUN apt update && \
    apt -y dist-upgrade && \
    apt install -y apt-utils                      \
                   autoconf                       \
                   build-essential                \
                   byobu                          \
                   clang-10                       \
                   cmake                          \
                   curl                           \
                   file                           \
                   g++-10                         \
                   gcc-10                         \
                   git                            \
                   htop                           \
                   jq                             \
                   libgmp-dev                     \
                   libomp-dev                     \
                   libterm-readline-gnu-perl      \
                   m4                             \
                   man                            \
                   --no-install-recommends tzdata \
                   patchelf                       \
                   python3-pip                    \
                   software-properties-common     \
                   sudo                           \
                   unzip                          \
                   vim                            \
                   virtualenv                     \
                   wget                           \
                   xz-utils                    && \
    apt autoremove -y && \
    apt autoclean -y  && \
    rm -rf /var/lib/apt/lists/*

RUN ["pip", "install", "toml", "argcomplete"]
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9  10 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 20 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9  10 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 20
    # Set timezone to UTC \