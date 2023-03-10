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

FROM debian-lxde:buster

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    tightvncserver xfonts-base xfonts-75dpi \
    xfonts-100dpi xfonts-scalable xvfb && \
    # LightDM needs an X Server, though we don't use it.
    echo '#!/bin/bash\nXvfb $1 -ac' > \
         /usr/bin/Xvfb-lightdm-wrapper && \
    chmod +x /usr/bin/Xvfb-lightdm-wrapper && \
    # Debian LightDM config is in /etc/lightdm/lightdm.conf
    echo '[LightDM]\nminimum-display-number=1\n[Seat:*]\n\ngreeter-hide-users=false\nxserver-command=/usr/bin/Xvfb-lightdm-wrapper\n[VNCServer]\nenabled=true\ndepth=24\ncommand=Xvnc -ac -rfbauth /tmp/lightdm/.vnc/passwd' > /etc/lightdm/lightdm.conf && rm -rf /var/lib/apt/lists/*;

#-------------------------------------------------------------------------------
# Example usage
#
# Build the image
# docker build -t debian-lxde-tightvnc:buster -f Dockerfile-no-xephyr .

