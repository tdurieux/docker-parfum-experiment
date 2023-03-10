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

# Install turbovnc from the sourceforge downloads page
# https://sourceforge.net/projects/turbovnc/files/
# This attempts to work out the latest version by "scraping" the page,
# but that could fail if the page format changes. If that happens the
# TVNC_VERSION variable could simply be set manually below.
# mkdir -p /usr/share/man/man1 fixes an issue installing default-jre
# see: https://github.com/debuerreotype/debuerreotype/issues/10
RUN mkdir -p /usr/share/man/man1 && \
    apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    curl ca-certificates default-jre libxt6 && \
    # Attempt to work out the latest turbovnc version from
    # https://sourceforge.net/projects/turbovnc/files/
    TVNC_VERSION=$( curl -f -sSL https://sourceforge.net/projects/turbovnc/files/ | grep "<span class=\"name\">[0-9]" | head -n 1 | cut -d \> -f2 | cut -d \< -f1) && \
    echo "turbovnc version: ${TVNC_VERSION}" && \
    # Given the version download and install turbovnc
    curl -f -sSL https://sourceforge.net/projects/turbovnc/files/${TVNC_VERSION}/turbovnc_${TVNC_VERSION}_amd64.deb -o turbovnc_${TVNC_VERSION}_amd64.deb && \
    dpkg -i turbovnc_*_amd64.deb && \
    # Tidy up packages only used for installing turbovnc.
    rm turbovnc_*_amd64.deb && \
    apt-get clean && \
    apt-get purge -y curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/opt/TurboVNC/bin/vncviewer"]

#-------------------------------------------------------------------------------
#
# To build the image
# docker build -t turbovnc-viewer -f Dockerfile-bullseye .
#

