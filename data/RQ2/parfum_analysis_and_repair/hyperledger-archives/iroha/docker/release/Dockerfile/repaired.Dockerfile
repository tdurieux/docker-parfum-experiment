FROM ubuntu:16.04

RUN apt-get update; \
    apt-get install --no-install-recommends -y libc-ares-dev && rm -rf /var/lib/apt/lists/*;

#Install iroha
COPY iroha.deb /tmp/iroha.deb
RUN apt-get install --no-install-recommends -y /tmp/iroha.deb; rm -rf /var/lib/apt/lists/*; \
    rm -f /tmp/iroha.deb

WORKDIR /opt/iroha_data

COPY entrypoint.sh wait-for-it.sh /
RUN chmod +x /entrypoint.sh /wait-for-it.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/sbin/init"]
