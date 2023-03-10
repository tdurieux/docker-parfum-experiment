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

FROM debian:stretch-slim

ENV LANG=en_GB.UTF-8
ENV TZ=Europe/London
ENV TVNC_WM=/usr/bin/jwm

# Install turbovnc from the sourceforge downloads page
# https://sourceforge.net/projects/turbovnc/files/
# This attempts to work out the latest version by "scraping" the page,
# but that could fail if the page format changes. If that happens the
# TVNC_VERSION variable could simply be set manually below.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    curl ca-certificates locales libssl1.0.2 jwm \
    libgl1-mesa-glx libgl1-mesa-dri xauth \
    x11-xkb-utils xkb-data x11-xserver-utils xfonts-base \
    xfonts-75dpi xfonts-100dpi xfonts-scalable && \
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
    apt-get purge -y curl ca-certificates && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    # Generate locales
    sed -i "s/^# *\($LANG\)/\1/" /etc/locale.gen && \
    locale-gen && \
    # Set up the timezone
    echo $TZ > /etc/timezone && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    DEBIAN_FRONTEND=noninteractive \
    dpkg-reconfigure tzdata && \
    # Tidy up JWM for single app use case
    sed -i "s/Desktops width=\"4\"/Desktops width=\"1\"/g" /etc/jwm/system.jwmrc && \
    sed -i "s/<TrayButton icon=\"\/usr\/share\/jwm\/jwm-red.svg\">root:1<\/TrayButton>//g" /etc/jwm/system.jwmrc && \
    sed -i "s/<TrayButton label=\"_\">showdesktop<\/TrayButton>//g" /etc/jwm/system.jwmrc && \
    sed -i "s/<Include>\/etc\/jwm\/debian-menu<\/Include>//g" /etc/jwm/system.jwmrc && \
    # We'll be exporting /tmp/.X11-unix as a volume and we need
    # the mode of /tmp/.X11-unix to be set to 1777
    mkdir /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix

VOLUME /tmp/.X11-unix

CMD /opt/TurboVNC/bin/vncserver $DISPLAY -ac -fg -geometry $GEOMETRY -nohttpd -rfbport 5900

#-------------------------------------------------------------------------------
#
# To build the image
# docker build -t turbovnc .
#

