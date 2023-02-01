FROM --platform=${TARGETPLATFORM} golang:1.17.8-alpine3.15 AS build
MAINTAINER LEE <info@15099.net>

ARG TARGETARCH
ARG GOPROXY=direct

ENV UPX_VERSION="3.96"
RUN apk add build-base bash make curl git perl ucl-dev zlib-dev \
  && wget https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-src.tar.xz -P /tmp/ \
  && cd /tmp/ \
  && tar xf upx-${UPX_VERSION}-src.tar.xz \
  && cd upx-${UPX_VERSION}-src \
  && make all \
  && mv ./src/upx.out /usr/bin/upx \
  && mkdir -p /asset/usr/bin/ \
  && git clone https://github.com/ehang-io/nps.git /tmp/nps \
  && cd /tmp/nps/ \
  && go get -d -v ./... \
  && CGO_ENABLED=0 go build -ldflags="-w -s -extldflags -static" ./cmd/npc/npc.go \
  && CGO_ENABLED=0 go build -ldflags="-w -s -extldflags -static" ./cmd/nps/nps.go \
  && upx -9 ./npc \
  && upx -9 ./nps \
  && mv ./npc /asset/usr/bin/npc \
  && mv ./nps /asset/usr/bin/nps \
  && mv ./web /asset/usr/bin/web
  
  
FROM --platform=${TARGETPLATFORM} alpine:3.15  

ARG NPS_VERSION 0.26.10
ENV MODE kcp
ENV WEB_PASSWORD password
ENV PUBLIC_VKEY 12345678
ENV BRIDGE_PORT 8024
ENV ALLOW_POSTS "53,9001-9009,10001,11000-12000"
ENV HTTP_PROXY_PORT 80
ENV HTTPS_PROXY_PORT 443
ENV DOMAIN youdomain.com
ENV HOSTNAME hostname
ENV TZ=Asia/Shanghai
LABEL name=nps


WORKDIR /

RUN set -x && \
        apk add -U tzdata ca-certificates openssl 
  
VOLUME /conf
COPY --from=build /asset/usr/bin/nps /nps  
COPY --from=build /asset/usr/bin/npc /npc
COPY --from=build /asset/usr/bin/web /web
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
