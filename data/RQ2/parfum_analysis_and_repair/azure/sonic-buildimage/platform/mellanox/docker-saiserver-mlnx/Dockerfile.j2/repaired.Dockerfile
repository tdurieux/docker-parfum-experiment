##
## Copyright (c) 2016-2022 NVIDIA CORPORATION & AFFILIATES.
## Apache-2.0
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
{% from "dockers/dockerfile-macros.j2" import install_debian_packages %}
FROM docker-config-engine-bullseye-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name
RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/$docker_container_name#%syslogtag%/;" /etc/rsyslog.conf

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

## Pre-install the fundamental packages
RUN apt-get update \
 && apt-get -y --no-install-recommends install \
    gdb \
    libboost-atomic1.71.0 && rm -rf /var/lib/apt/lists/*;

COPY \
{% for deb in docker_saiserver_mlnx_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/

COPY \
{% for deb in docker_saiserver_mlnx_pydebs.split(' ') -%}
python-debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/

RUN apt-get install -y --no-install-recommends libxml2 iptables libbsd0 protobuf-c-compiler protobuf-compiler python3-protobuf libprotobuf-c1 python3-future python3-ipaddr libnet1 pkg-config asciidoc xmlto && rm -rf /var/lib/apt/lists/*;

{{ install_debian_packages(docker_saiserver_mlnx_debs.split(' ')) }}

COPY ["start.sh", "/usr/bin/"]

COPY ["supervisord.conf", "/etc/supervisor/conf.d/"]

COPY ["profile.ini", "portmap.ini", "/etc/sai/"]

COPY ["sai_2700.xml", "/usr/share/"]

## Clean up
RUN apt-get clean -y; apt-get autoclean -y; apt-get autoremove -y
RUN rm -rf /debs

ENTRYPOINT ["/usr/local/bin/supervisord"]
