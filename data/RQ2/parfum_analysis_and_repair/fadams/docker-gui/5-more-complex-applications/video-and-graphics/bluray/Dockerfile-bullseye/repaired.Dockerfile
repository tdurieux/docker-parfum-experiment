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

# Install vlc and makemkv
RUN sed -i 's/main/main contrib/' \
        /etc/apt/sources.list && \
    apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
	vlc apt-transport-https wget gnupg ca-certificates \
    libdvd-pkg libv4l-0 libvdpau1 mesa-vdpau-drivers \
    libgl1-mesa-glx libgl1-mesa-dri && \
    dpkg-reconfigure libdvd-pkg && \
    # As apt-key is deprecated the following wget replaces
    # apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 9E5738E866C5E6B2
    # The URL is the public key obtained by searching
    # keyserver.ubuntu.com for 0x9E5738E866C5E6B2
    wget -O /usr/share/keyrings/makemkv-archive.key "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x042ae5b1b4f852ffbcdabd8ef9b3bde7f60856b2" && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/makemkv-archive.key] https://ramses.hjramses.com/deb/makemkv bullseye main" > /etc/apt/sources.list.d/makemkv.list && \
    apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends install -y makemkv-bin makemkv-oss && \
    # Remove packages needed only for installing libdvdcss
    cp /usr/lib/x86_64-linux-gnu/libdvdcss.so.2.2.0 \
       /usr/lib/x86_64-linux-gnu/libdvdcss.so.2.2.0.bak && \
    apt-get clean && \
    apt-get purge -y apt-transport-https wget libdvd-pkg && \
    apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/* && \
    # https://www.makemkv.com/forum/viewtopic.php?t=7009
    cd /usr/lib/x86_64-linux-gnu && \
    ln -s libmmbd.so.0 libaacs.so.0 && \
    ln -s libmmbd.so.0 libbdplus.so.0 && \
    mv libdvdcss.so.2.2.0.bak libdvdcss.so.2.2.0 && \
    ln -s libdvdcss.so.2.2.0 libdvdcss.so && \
    cp /etc/pulse/client.conf \
       /etc/pulse/client-noshm.conf && \
    sed -i "s/; enable-shm = yes/enable-shm = no/g" \
        /etc/pulse/client-noshm.conf

ENTRYPOINT ["vlc"]

#-------------------------------------------------------------------------------
#
# To build the image
# docker build -t vlc-bluray -f Dockerfile-bullseye .
#

