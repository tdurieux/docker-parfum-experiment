FROM pihole/pihole:latest

COPY install.sh pihole-updatelists.* /tmp/pihole-updatelists/

RUN apt-get update && \
    apt-get install --no-install-recommends -Vy wget php-cli php-sqlite3 php-intl php-curl && \
    apt-get clean && \
    rm -fr /var/cache/apt/* /var/lib/apt/lists/*.lz4 && rm -rf /var/lib/apt/lists/*;

RUN chmod +x /tmp/pihole-updatelists/install.sh && \
    bash /tmp/pihole-updatelists/install.sh docker && \
    rm -fr /tmp/pihole-updatelists
