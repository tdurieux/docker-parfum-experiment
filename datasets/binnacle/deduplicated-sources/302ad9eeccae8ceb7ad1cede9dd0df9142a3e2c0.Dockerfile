#
# Dockerfile for frp-arm
#

FROM alpine
MAINTAINER EasyPi Software Foundation

ENV FRP_VERSION 0.21.0
ENV FRP_URL https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_arm.tar.gz

WORKDIR /opt/frp

RUN set -xe \
    && apk add --no-cache curl tar \
    && curl -sSL $FRP_URL | tar xz --strip 1 \
    && apk del curl tar

EXPOSE 7000/tcp 7000/udp 7500/tcp

CMD ["./frps", "-c", "frps.ini"]
