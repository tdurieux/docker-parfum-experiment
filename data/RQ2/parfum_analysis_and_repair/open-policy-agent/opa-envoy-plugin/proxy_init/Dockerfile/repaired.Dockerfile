FROM ubuntu:xenial

ADD ./proxy_init.sh /proxy_init.sh
RUN chmod 755 /proxy_init.sh

RUN apt-get update && apt-get install --no-install-recommends -y iptables && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/proxy_init.sh"]
