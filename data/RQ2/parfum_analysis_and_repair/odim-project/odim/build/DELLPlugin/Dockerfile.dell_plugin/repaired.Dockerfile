#(C) Copyright [2020] Hewlett Packard Enterprise Development LP
#
#Licensed under the Apache License, Version 2.0 (the "License"); you may
#not use this file except in compliance with the License. You may obtain
#a copy of the License at
#
#    http:#www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#License for the specific language governing permissions and limitations
# under the License.
FROM odimra_builddep:tst as build-stage

FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y --no-install-recommends uuid-runtime && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get update \
    && apt-get install --no-install-recommends -y systemd systemd-sysv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt update
RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/dell_plugin_config
RUN mkdir /etc/dell_plugin_config
RUN mkdir /etc/dell_plugin_certs

RUN  groupadd -r -g 1235 plugin
RUN  useradd -s /bin/bash -u 1235 -m -d /home/plugin -r -g plugin plugin

COPY DELLPlugin/dell_plugin_config/config_dell_plugin.json /var/dell_plugin_config/
COPY DELLPlugin/dell_plugin_config/platformconfig.toml /var/dell_plugin_config/
COPY DELLPlugin/start_plugin.sh /bin/
COPY DELLPlugin/edit_config.sh /var/tmp/dell_plugin-edit_config.sh
COPY DELLPlugin/command.sh /bin/
COPY --from=build-stage /odimra/plugin-dell/plugin-dell /bin/

RUN  chown -R plugin:plugin /etc/dell_plugin_config
RUN  chown -R plugin:plugin /var/dell_plugin_config
RUN  chown -R plugin:plugin /etc/dell_plugin_certs


VOLUME [ "/sys/fs/cgroup" ]

ENTRYPOINT  ["/lib/systemd/systemd"]
