FROM ubuntu:20.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y curl build-essential libssl-dev libpcre3-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /ats
RUN curl -f -L https://archive.apache.org/dist/trafficserver/trafficserver-9.0.0.tar.bz2 > ats.tar.bz2 && \
    tar xf ats.tar.bz2 && \
    cd trafficserver-9.0.0 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/ts && \
    make && \
    make install && rm ats.tar.bz2

RUN apt -y --no-install-recommends install netcat && rm -rf /var/lib/apt/lists/*;
COPY ./remap.config /opt/ts/etc/trafficserver/remap.config
RUN chmod +r /opt/ts/etc/trafficserver/remap.config

CMD ["/opt/ts/bin/traffic_manager"]