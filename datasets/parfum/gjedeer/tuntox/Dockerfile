FROM debian:sid AS builder
WORKDIR /root
RUN apt update && apt -y install pkg-config build-essential make libtoxcore-dev dh-make git python3-jinja2 python3-requests
RUN git clone https://github.com/gjedeer/tuntox.git && cd tuntox && tar -zcf ../tuntox_0.0.10.1.orig.tar.gz . && dpkg-buildpackage -us -uc -v0.0.10.1-1

FROM alpine:latest

COPY scripts/tokssh /usr/bin/tokssh
COPY --from=0 /root/tuntox/tuntox /usr/bin/tuntox

RUN chmod +x /usr/bin/tuntox  /usr/bin/tokssh && \
	mkdir /data

EXPOSE 33446/tcp
EXPOSE 33446:33447/udp

CMD ["/usr/bin/tuntox", "-C", "/data", "-t", "33446", "-u", "33446:33447", "-d"]
