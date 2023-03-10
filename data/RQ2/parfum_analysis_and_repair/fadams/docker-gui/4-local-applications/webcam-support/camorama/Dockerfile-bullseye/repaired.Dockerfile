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
# In order for configuration to be saved correctly the host system needs to
# have gconf2 installed. This is no longer the default for modern GNOME 3
# based distros such as Ubuntu 18.04 as gconf is deprecated, so it must be
# explicitly added using sudo apt-get install gconf2.

FROM debian:bullseye-slim

# Install camorama
# Unfortunately camorama isn't in the buster or bullseye repos so we
# have to built it from source ourselves.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    # Add the packages used
    apt-get install -y --no-install-recommends \
	libcanberra-gtk-module git ca-certificates autoconf automake \
    make gnome-common libv4l-dev gdk-pixbuf-2.0 gtk+-3.0 \
    librsvg2-common && \
    cd /usr/src && \
    git clone https://github.com/alessio/camorama.git && \
    cd camorama && ./autogen.sh --disable-nls && \
    make -j$(getconf _NPROCESSORS_ONLN) && make install && \
    # Remove miscellaneous packages used for installation and build.
    rm -rf /usr/src/camorama && \
    apt-get purge -y git ca-certificates autoconf automake make \
    autoconf-archive autotools-dev gcc-10 libllvm11 iso-codes \
    perl-modules-5.32 python3.9-minimal libpython3.9-minimal \
    tzdata && \
    apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["camorama"]

#-------------------------------------------------------------------------------
# Example usage
# 
# Build the image
# docker build -t camorama -f Dockerfile-bullseye .
#