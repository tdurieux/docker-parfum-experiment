FROM openresty/openresty:1.21.4.1rc3-bullseye-fat

COPY build/docker/navigator/sources.list /etc/apt/sources.list

RUN apt-get update && \
    apt-get install --no-install-recommends -y procps iptables && \
    rm -rf /var/lib/apt/lists/*
