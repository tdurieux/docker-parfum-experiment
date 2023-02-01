FROM debian:jessie

MAINTAINER Jaime Soriano Pastor <jsoriano@tuenti.com>

RUN apt-get update && apt-get install -y wget && apt-get clean

RUN wget "https://caddyserver.com/download/build?os=linux&arch=amd64&features=" -O - | tar zxv -C /usr/local/bin caddy && \
	mkdir -p /etc/caddy && \
	echo localhost :8080 > /etc/caddy/Caddyfile

COPY Caddyfile.tpl /etc/kube2lb/Caddyfile.tpl
COPY kube2lb /usr/local/bin/kube2lb
COPY entrypoint.sh /entrypoint.sh

ENV TEMPLATE /etc/kube2lb/Caddyfile.tpl

EXPOSE 80

CMD ["/entrypoint.sh"]
