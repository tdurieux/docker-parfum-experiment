# Copyright (c) 2019-2020, RTE (https://www.rte-france.com)
# See AUTHORS.txt
# This Source Code Form is subject to the terms of the Mozilla Public License, version 2.0.
# If a copy of the Mozilla Public License, version 2.0 was not distributed with this file,
# you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
# This file is part of LightSim2grid, LightSim2grid implements a c++ backend targeting the Grid2Op platform.

# Use an official Python runtime as a parent image
FROM python:3.8-buster

MAINTAINER Benjamin DONNOT <benjamin.donnot@rte-france.com>

ENV DEBIAN_FRONTEND noninteractive

ARG ls_version

RUN apt-get update && \
    apt-get install -y \
    less \
    apt-transport-https \
    build-essential \
    git \
    ssh \
    tar \
    gzip

# install grid2op and l2rpn-baselines and pybind11
RUN pip3 install -U grid2op[optional] pybind11

# install lightsim
RUN git clone --recurse-submodules https://github.com/BDonnot/lightsim2grid.git
WORKDIR /lightsim2grid
RUN git pull
RUN git remote update
RUN git fetch --all --tags
RUN git checkout "tags/${ls_version}" -b "${ls_version}-branch"
RUN make
RUN pip install -U .
RUN make clean purge
WORKDIR /

# Make port 80 available to the world outside this container
EXPOSE 80
