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

# Install x11vnc and xserver-xorg-video-dummy.
# This Dockerfile installs noVNC V0.6.2 which
# may work better on older browsers.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    curl ca-certificates \
    libgl1-mesa-glx libgl1-mesa-dri \
    x11vnc xserver-xorg-video-dummy locales jwm && \
    # Download noVNC.
    NOVNC_VERSION=0.6.2 && \
    curl -f -sSL https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz | tar -xzv -C /usr/local/bin && \
    cd /usr/local/bin/noVNC-${NOVNC_VERSION} && \
    # Tweak noVNC configuration as the defaults point to 
    # websockify not the built-in x11vnc websocket support.
    sed -i "s/UI.initSetting('port', port)/UI.initSetting('port', 5900)/g" include/ui.js && \
    sed -i "s/UI.initSetting('path', 'websockify')/UI.initSetting('path', '')/g" include/ui.js && \
    # Renaming vnc.html to index.vnc seems necessary as the
    # x11vnc built-in web server seems to serve index.vnc
    # by default and there's no obvious configuration
    # option to change this.
    mv vnc.html index.vnc && \
    mv /usr/local/bin/noVNC-${NOVNC_VERSION} \
       /usr/local/bin/noVNC && \
    #
    # Create script to start Xorg, jwm and x11vnc
    echo '#!/bin/bash\nXorg $DISPLAY -cc 4 &\nsleep 0.5\njwm &\nx11vnc -forever -usepw -httpdir /usr/local/bin/noVNC' > /usr/local/bin/startup && \
    chmod +x /usr/local/bin/startup && \
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
    # We export /tmp/.X11-unix as a volume and we need
    # the mode of /tmp/.X11-unix to be set to 1777
    mkdir /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix && \
    # Tidy up
    apt-get clean && \
    apt-get purge -y curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

VOLUME /tmp/.X11-unix

COPY xorg.conf /etc/X11/xorg.conf

CMD ["/usr/local/bin/startup"]

#-------------------------------------------------------------------------------
#
# To build the image
# docker build -t x11novnc-xdummy -f Dockerfile-0.6.2-standalone .
#

