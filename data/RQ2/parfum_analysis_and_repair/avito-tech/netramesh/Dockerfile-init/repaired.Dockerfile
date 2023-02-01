FROM debian:stretch

RUN apt-get update && apt-get install --no-install-recommends -y iptables && rm -rf /var/lib/apt/lists/*;

COPY iptables-rules.sh /

ENTRYPOINT ["/iptables-rules.sh"]
