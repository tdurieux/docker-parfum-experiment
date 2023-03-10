###########################################################################
# Copyright 2020 Broadband Forum
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###########################################################################
FROM ubuntu:16.04

# Setup proxy if container is run on behind proxy host
ARG http_proxy
ARG https_proxy
ARG INFLUX_USER
ARG INFLUX_PW
ARG INFLUX_ORG
ARG INFLUX_BUCKET

ENV INFLUXDB_VERSION 2.0.0-beta.2
ENV DEBIAN_FRONTEND noninteractive
ENV TERM vt100

RUN set +ex && \
    apt-get update && \
    apt-get install --no-install-recommends -y apt-utils ca-certificates tzdata net-tools iproute2 wget && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt.dpkg.cache.log} && \
    wget --no-verbose --quiet https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB_VERSION}_linux_amd64.tar.gz && \
    mkdir -p /usr/src && \
    tar -C /usr/src -xzf influxdb_${INFLUXDB_VERSION}_linux_amd64.tar.gz && \
    rm influxdb_${INFLUXDB_VERSION}_linux_amd64.tar.gz && \
    mkdir /etc/influxdb && \
    chmod +x /usr/src/influxdb*/influx* && \
    cp -p /usr/src/influxdb*/influx* /usr/bin/ && \
    cp -p /usr/src/influxdb*/README.md /etc/influxdb/ && \
    cp -p /usr/src/influxdb*/LICENSE /etc/influxdb/ && \
    mkdir /etc/influxdb/example && \
    rm -rf /usr/src /root/.gnupg && rm -rf /var/lib/apt/lists/*;

EXPOSE 9999 22

RUN mkdir -p /var/opt/influxdb

COPY init-influxdb.sh /etc/influxdb/init-influxdb.sh
RUN chmod 755 /etc/influxdb/init-influxdb.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
COPY example/storeQuery.sh /etc/influxdb/example
RUN chmod 755 /etc/influxdb/example/storeQuery.sh
COPY example/rmRecords.sh /etc/influxdb/example
RUN chmod 755 /etc/influxdb/example/rmRecords.sh
COPY influxdbfiles.tgz /etc/influxdb
RUN tar -S -C /var/opt -xf /etc/influxdb/influxdbfiles.tgz && rm /etc/influxdb/influxdbfiles.tgz

ENTRYPOINT ["/entrypoint.sh"]
CMD ["influxd"]
