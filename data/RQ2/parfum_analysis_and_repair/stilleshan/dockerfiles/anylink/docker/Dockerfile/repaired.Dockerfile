FROM ubuntu:18.04
WORKDIR /
COPY docker_entrypoint.sh docker_entrypoint.sh
RUN mkdir /anylink && apt update && apt install --no-install-recommends -y wget iptables tar iproute2 && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["/docker_entrypoint.sh"]
#CMD ["/anylink/anylink","-conf=/anylink/conf/server.toml"]
