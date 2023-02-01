FROM alpine:3.9
LABEL maintainer="Pål Ruud <ruudud@gmail.com>"

RUN apk --no-cache add bash curl dnsmasq ed --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main

RUN curl -sSL https://download.docker.com/linux/static/stable/x86_64/docker-18.09.5.tgz | tar zx -C /tmp &&\
    mv /tmp/docker/docker /usr/local/bin/ &&\
    rm -rf /tmp/docker &&\
    mkdir -p /etc/dnsmasq.d

COPY dnsmasq.conf /etc/dnsmasq.conf
COPY run.sh /run.sh

ENV DNS_DOMAIN="test" FALLBACK_DNS="8.8.8.8" EXTRA_HOSTS="" HOSTMACHINE_IP="172.17.0.1" NAMING="default" NETWORK="bridge"

EXPOSE 53/udp

ENTRYPOINT ["/run.sh"]
