#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# Run glxgears in a container.
# This image uses the simple approach of sharing the host's X11 socket and GPU
# device with the container. This method requires the container, GPU device and
# display to be on the same host, but gives performance that is equivalent to
# running the application directly (i.e. not in a container) on the host.

# With this approach we build Nvidia libglvnd inside the container.
# This means that we don't have to bind-mount any Nvidia libraries from the
# host to the container, which arguably makes the container that bit more
# isolated. This image is a little bit bloaty as it requires all of the build
# tools in order to build libglvnd. A better approach might be to separate
# the build into a separate container whose job is to build libglvnd and
# export the built libraries into a libglvnd.tar.gz which you could then ADD
# into an image, which should result in much smaller images.
# Using this approach will result in Nvidia specific Dockerfiles whereas the
# approach of bind-mounting the required libraries from the host will result in
# Dockerfiles that can be used with different GPU drivers, where the wrangling
# may be done in the launch script.

FROM debian:stretch-slim

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    make \
    automake \
    autoconf \
    libtool \
    pkg-config \
    python \
    libxext-dev \
    libx11-dev \
    x11proto-gl-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/libglvnd
RUN git clone --branch=v1.0.0 https://github.com/NVIDIA/libglvnd.git . && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local --libdir=/usr/local/lib/x86_64-linux-gnu && \
    make -j"$(nproc)" install-strip && \
    find /usr/local/lib/x86_64-linux-gnu -type f -name 'lib*.la' -delete

# Only the first line below seems to be needed with an Ubuntu base image, but
# all of it is needed when using debian:stretch-slim
RUN echo '/usr/local/lib/x86_64-linux-gnu' >> /etc/ld.so.conf.d/glvnd.conf && \
    ldconfig && \
    echo '/usr/local/$LIB/libGL.so.1' >> /etc/ld.so.preload && \
    echo '/usr/local/$LIB/libEGL.so.1' >> /etc/ld.so.preload

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics

#-------------------------------------------------------------------------------

# Install glxgears
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    # Add the packages used
    apt-get install -y --no-install-recommends \
	mesa-utils && \
	rm -rf /var/lib/apt/lists/*

ENV LIBGL_DEBUG verbose
ENTRYPOINT ["glxgears"]

#-------------------------------------------------------------------------------
# Example usage
#
# Build the image
# docker build -t glxgears-libglvnd -f Dockerfile-libglvnd .
#
# To run:
#
# DOCKER_COMMAND=docker
# # If user isn't in docker group prefix docker with sudo
# if ! (id -nG $(id -un) | grep -qw docker); then
#     DOCKER_COMMAND="sudo $DOCKER_COMMAND"
# fi
#
# # Create .Xauthority.docker file with wildcarded hostname.
# XAUTH=${XAUTHORITY:-$HOME/.Xauthority}
# DOCKER_XAUTHORITY=${XAUTH}.docker
# cp --preserve=all $XAUTH $DOCKER_XAUTHORITY
# xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $DOCKER_XAUTHORITY nmerge -
#
# $DOCKER_COMMAND run --runtime=nvidia --rm \
#     -u $(id -u):$(id -g) \
#     -v /etc/passwd:/etc/passwd:ro \
#     -e DISPLAY=unix$DISPLAY \
#     -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
#     -e XAUTHORITY=$DOCKER_XAUTHORITY \
#     -v $DOCKER_XAUTHORITY:$DOCKER_XAUTHORITY:ro \
#     glxgears-libglvnd

