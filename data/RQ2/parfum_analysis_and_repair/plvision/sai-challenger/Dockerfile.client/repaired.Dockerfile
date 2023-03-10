FROM debian:buster-slim

MAINTAINER andriy.kokhan@gmail.com

RUN echo "deb [arch=amd64] http://debian-archive.trafficmanager.net/debian/ buster main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb-src [arch=amd64] http://debian-archive.trafficmanager.net/debian/ buster main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb [arch=amd64] http://debian-archive.trafficmanager.net/debian-security/ buster/updates main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb-src [arch=amd64] http://debian-archive.trafficmanager.net/debian-security/ buster/updates main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb [arch=amd64] http://debian-archive.trafficmanager.net/debian buster-backports main" >> /etc/apt/sources.list

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Install generic packages
RUN apt-get -o Acquire::Check-Valid-Until=false update && apt-get install --no-install-recommends -y \
        apt-utils \
        procps \
        build-essential \
        python3 \
        python3-pip \
        iproute2 \
        rsyslog \
        supervisor && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir redis pytest pytest_dependency pytest-html

# Install PTF dependencies
RUN pip3 install --no-cache-dir scapy

# Disable kernel logging support
RUN sed -ri '/imklog/s/^/#/' /etc/rsyslog.conf

COPY scripts/client/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY scripts/veth-create.sh /usr/bin/veth-create.sh

WORKDIR /sai-challenger/tests

CMD ["/usr/bin/supervisord"]

