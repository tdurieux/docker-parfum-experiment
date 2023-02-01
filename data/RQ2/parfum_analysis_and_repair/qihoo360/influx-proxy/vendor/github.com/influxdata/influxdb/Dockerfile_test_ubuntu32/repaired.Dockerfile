FROM 32bit/ubuntu:14.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y python-software-properties software-properties-common git && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:evarlast/golang1.4
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y -o Dpkg::Options::="--force-overwrite" golang-go && rm -rf /var/lib/apt/lists/*;

ENV GOPATH=/root/go
RUN mkdir -p /root/go/src/github.com/influxdata/influxdb
RUN mkdir -p /tmp/artifacts

VOLUME /root/go/src/github.com/influxdata/influxdb
VOLUME /tmp/artifacts
