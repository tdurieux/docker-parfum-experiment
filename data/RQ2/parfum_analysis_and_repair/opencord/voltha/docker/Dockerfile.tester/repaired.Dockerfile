# Copyright 2018 the original author or authors.
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
ARG TAG=latest
ARG REGISTRY=
ARG REPOSITORY=

FROM ${REGISTRY}${REPOSITORY}voltha-base:${TAG}

MAINTAINER Voltha Community <info@opennetworking.org>

RUN apt update && apt install --no-install-recommends -y pppoe iperf isc-dhcp-client tcpdump net-tools iproute2 iputils-ping wpasupplicant wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/troglobit/mcjoin/releases/download/v2.4/mcjoin_2.4_amd64.deb
RUN dpkg -i mcjoin_2.4_amd64.deb

COPY config/igmp.py /usr/local/bin
COPY config/igmpv3.py /usr/local/bin

RUN chmod 755 /usr/local/bin/igmp.py

COPY config/wpa_supplicant.conf /etc/wpa_supplicant/

COPY config/pppoe-client-config /etc/ppp/peers/seba
