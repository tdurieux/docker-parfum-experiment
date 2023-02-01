FROM ubuntu:bionic AS builder

RUN set -xe; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install --no-install-recommends -y cmake g++ git libmysqlclient-dev; rm -rf /var/lib/apt/lists/*; \
    cd /opt; \
    git clone https://github.com/runelite/runelite-mysql.git; \
    cd runelite-mysql; \
    cmake .; \
    make;

FROM mariadb:10.2-bionic

RUN set -xe; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install --no-install-recommends -y nftables; rm -rf /var/lib/apt/lists/*; \
    apt-get clean; \
    rm /var/lib/apt/list/* -rf;

COPY --from=builder /opt/runelite-mysql/libxp.so /opt/runelite-mysql/libxp.so
COPY entrypoint.sh /entrypoint.sh
COPY nftables.conf /etc/nftables.conf
COPY init.sql /docker-entrypoint-initdb.d/10-init.sql

ENTRYPOINT ["/entrypoint.sh"]
