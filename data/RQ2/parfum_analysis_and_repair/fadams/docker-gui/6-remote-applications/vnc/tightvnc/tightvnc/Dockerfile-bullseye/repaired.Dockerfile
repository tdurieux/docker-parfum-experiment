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

ENV LANG=en_GB.UTF-8
ENV TZ=Europe/London

# Install tightvncserver
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    tightvncserver libgl1-mesa-glx libgl1-mesa-dri \
    x11-xserver-utils locales jwm xfonts-base \
    xfonts-75dpi xfonts-100dpi xfonts-scalable && \
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

CMD vncserver $DISPLAY -ac -geometry $GEOMETRY -rfbport 5900 && tail -F ~/.vnc/*.log

#-------------------------------------------------------------------------------
# 
# To build the image
# docker build -t tightvnc -f Dockerfile-bullseye .
#