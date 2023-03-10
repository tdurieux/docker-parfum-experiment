# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This docker file is based upon https://hub.docker.com/r/openthread/otbr_amd64_linux/dockerfile
# openthread/otbr_amd64_linux provides the basic openthread otbr docker setup and configuration from ubuntu base image
# further, this docker file provides the basic setup and configuration for WiFi station device.

FROM openthread/otbr:focal
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y upgrade

RUN apt-get install --no-install-recommends -y \
    psmisc \
    dhcpcd5 \
    wpasupplicant \
    wireless-tools \
    iproute2 && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /etc/wpa_supplicant && \
    echo "ctrl_interface=/run/wpa_supplicant" >> /etc/wpa_supplicant/wpa_supplicant.conf && \
    echo "update_config=1" >> /etc/wpa_supplicant/wpa_supplicant.conf

ENTRYPOINT service dbus start && \
           sleep 1 && \
           otbr-agent -I wpan0 spinel+hdlc+uart:///dev/ttyUSB0 || sleep infinity
