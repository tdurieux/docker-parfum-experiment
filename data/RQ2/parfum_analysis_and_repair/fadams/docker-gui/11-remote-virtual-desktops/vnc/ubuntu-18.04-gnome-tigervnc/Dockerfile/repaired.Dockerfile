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

FROM ubuntu-gnome-vgl:18.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    tigervnc-common tigervnc-standalone-server \
    xfonts-base xfonts-75dpi xfonts-100dpi \
    xfonts-scalable && \
    echo '[LightDM]\nminimum-display-number=1\n[Seat:*]\nuser-session=ubuntu-xorg\nxserver-command=/usr/bin/Xephyr-lightdm-wrapper\n[VNCServer]\nenabled=true\ndepth=24\ncommand=Xvnc -ac -rfbauth /tmp/lightdm/.vnc/passwd' > /etc/lightdm/lightdm.conf.d/70-ubuntu.conf && rm -rf /var/lib/apt/lists/*;

#-------------------------------------------------------------------------------
# Example usage
#
# Build the image
# docker build -t ubuntu-gnome-tigervnc:18.04 .

