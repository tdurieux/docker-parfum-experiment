FROM nordstrom/baseimage-ubuntu:14.04.1
MAINTAINER Innovation Platform Team "invcldtm@nordstrom.com"

ENV INFLUXDB_RELEASE 0.8.8
ADD dist/influxdb_${INFLUXDB_RELEASE}_amd64.deb /
RUN mkdir -p /opt/influxdb/shared/data && \
    dpkg -i /influxdb_${INFLUXDB_RELEASE}_amd64.deb && \
    rm -rf /opt/influxdb/shared/data && \
    chown -R daemon:daemon /opt/influxdb

ADD conf/config.toml /opt/influxdb/shared/config.toml

# HTTP API port
EXPOSE 8086
# Admin port
EXPOSE 8083
# Raft port
EXPOSE 8090
# Replication port (protobuf)
EXPOSE 8099

ENTRYPOINT ["/usr/bin/influxdb", "-config", "/opt/influxdb/shared/config.toml"]
