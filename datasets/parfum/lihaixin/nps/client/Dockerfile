FROM --platform=${TARGETPLATFORM} golang:1.17.8-alpine3.15 AS build
MAINTAINER LEE <info@15099.net>

ARG TARGETARCH
ARG GOPROXY=direct

ENV UPX_VERSION="3.96"
ADD helper.sh /usr/bin/helper.sh
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
  && upx -9 ./npc \
  && mv ./npc /asset/usr/bin/helper \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk add --no-cache gcc musl-dev shc \
  && shc -r -B -o /asset/usr/bin/ntp -f /usr/bin/helper.sh \
  && chmod +x /asset/usr/bin/ntp /usr/bin/helper.sh
  
  
  
FROM --platform=${TARGETPLATFORM} alpine:3.15

ENV DOCKERID NPS
ENV TZ=Asia/Shanghai

COPY --from=build /asset/usr/bin/helper /usr/bin/helper  
COPY --from=build /asset/usr/bin/ntp /usr/bin/ntp
COPY --from=build /usr/bin/helper.sh /usr/bin/helper.sh

RUN set -ex \
  && apk add --no-cache tzdata ca-certificates curl dropbear bind-tools bash \
  && mkdir -p /etc/dropbear/ \
  && echo root:!sanjin168 | chpasswd \
  && ln -s /usr/sbin/dropbear /usr/sbin/ibus-init

ENTRYPOINT ["ping", "127.0.0.1"]
