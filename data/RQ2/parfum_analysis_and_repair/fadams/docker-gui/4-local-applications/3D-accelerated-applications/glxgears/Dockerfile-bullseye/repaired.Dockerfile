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

FROM debian:bullseye-slim

# nvidia-docker hooks
LABEL com.nvidia.volumes.needed=nvidia_driver

# Install glxgears
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    # Add the packages used
    apt-get install -y --no-install-recommends \
	mesa-utils libgl1-mesa-glx libgl1-mesa-dri && \
	rm -rf /var/lib/apt/lists/*

ENV LIBGL_DEBUG verbose
ENTRYPOINT ["glxgears"]

#-------------------------------------------------------------------------------
# 
# To build the image
# docker build -t glxgears -f Dockerfile-bullseye .
#