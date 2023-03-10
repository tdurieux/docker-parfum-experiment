FROM tykio/tyk-plugin-compiler:v3.2.2 AS builder

WORKDIR /go/src

COPY api ./api

COPY common ./common

WORKDIR /plugin-source/

COPY gateway/tyk/v3.2.2/* ./.

RUN /build.sh plugin.so 1

FROM busybox
WORKDIR /plugins
COPY --from=builder ["/plugin-source/plugin.so", "./tyk-plugin.so"]