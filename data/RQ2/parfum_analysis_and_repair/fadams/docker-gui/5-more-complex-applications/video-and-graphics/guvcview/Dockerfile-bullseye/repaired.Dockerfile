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

FROM debian:bullseye-slim

# nvidia-docker hooks (Only needed for Nvidia Docker V1)
LABEL com.nvidia.volumes.needed=nvidia_driver

# Install guvcview
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    # Add the packages used
    apt-get install -y --no-install-recommends \
	libcanberra-gtk-module libcanberra-gtk3-module \
    guvcview pulseaudio librsvg2-common \
    libgl1-mesa-glx libgl1-mesa-dri && \
	rm -rf /var/lib/apt/lists/* && \
    cp /etc/pulse/client.conf \
       /etc/pulse/client-noshm.conf && \
    sed -i "s/; enable-shm = yes/enable-shm = no/g" \
        /etc/pulse/client-noshm.conf

ENTRYPOINT ["guvcview"]

#-------------------------------------------------------------------------------
# Example usage
# 
# Build the image
# docker build -t guvcview -f Dockerfile-bullseye .