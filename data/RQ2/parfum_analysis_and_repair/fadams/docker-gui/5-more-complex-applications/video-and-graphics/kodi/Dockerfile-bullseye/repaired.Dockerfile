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

# Install kodi
RUN sed -i 's/main/main contrib/' \
        /etc/apt/sources.list && \
    apt-get update && DEBIAN_FRONTEND=noninteractive \
    # Add the packages used
    apt-get install -y --no-install-recommends \
    apt-transport-https wget gnupg ca-certificates \
    kodi libdvd-pkg libdvdnav4 libvdpau1 mesa-vdpau-drivers \
    libgl1-mesa-glx libgl1-mesa-dri && \
    dpkg-reconfigure libdvd-pkg && \
    # Remove packages needed only for installing libdvdcss
    cp /usr/lib/x86_64-linux-gnu/libdvdcss.so.2.2.0 \
       /usr/lib/x86_64-linux-gnu/libdvdcss.so.2.2.0.bak && \
    apt-get clean && \
    apt-get purge -y apt-transport-https wget libdvd-pkg && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    cd /usr/lib/x86_64-linux-gnu && \
    mv libdvdcss.so.2.2.0.bak libdvdcss.so.2.2.0 && \
    ln -s libdvdcss.so.2.2.0 libdvdcss.so && \
    cp /etc/pulse/client.conf \
       /etc/pulse/client-noshm.conf && \
    sed -i "s/; enable-shm = yes/enable-shm = no/g" \
        /etc/pulse/client-noshm.conf

ENTRYPOINT ["kodi"]

#-------------------------------------------------------------------------------
# 
# To build the image
# docker build -t kodi -f Dockerfile-bullseye .
#