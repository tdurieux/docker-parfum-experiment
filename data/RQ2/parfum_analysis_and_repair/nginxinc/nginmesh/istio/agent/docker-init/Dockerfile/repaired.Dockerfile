FROM debian:stretch-slim
RUN apt-get update && apt-get install --no-install-recommends -y iptables && rm -rf /var/lib/apt/lists/*;
ADD prepare_proxy.sh /
ENTRYPOINT ["/prepare_proxy.sh"]
