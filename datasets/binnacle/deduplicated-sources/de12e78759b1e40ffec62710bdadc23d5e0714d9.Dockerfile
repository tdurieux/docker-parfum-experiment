FROM alpine:latest
MAINTAINER "The Alpine Project" <admin@jiobxn.com>
ARG LATEST="0"

RUN apk update && apk add openvpn openssl tzdata bash && rm -rf /var/cache/apk/*
RUN \cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN echo -e '#!/bin/bash\nif [ -f /key/pwd.txt ];then\n  openvpn --config /key/client.ovpn --auth-user-pass /key/pwd.txt;\nelse\n  openvpn --config /key/client.ovpn;\nfi' >/ovpn.sh
RUN chmod +x /ovpn.sh

VOLUME /key

ENTRYPOINT ["/ovpn.sh"]

# docker build -t ovpn .
# docker run -d --restart unless-stopped --privileged --network host -v /docker/ovpn:/key --name ovpn ovpn
# docker run -d --restart unless-stopped --cap-add=NET_ADMIN --device=/dev/net/tun --network host -v /docker/ovpn:/key --name ovpn ovpn
