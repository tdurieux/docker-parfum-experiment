ARG GOVERSION=latest
FROM golang:$GOVERSION AS builder

WORKDIR /src
COPY . .

ENV CGO_ENABLED=0
ENV BUILD_HOST=syncthing.net
ENV BUILD_USER=docker
RUN rm -f strelaysrv && go run build.go -no-upgrade build strelaysrv

FROM alpine

EXPOSE 22067 22070

VOLUME ["/var/strelaysrv"]

RUN apk add --no-cache ca-certificates su-exec

COPY --from=builder /src/strelaysrv /bin/strelaysrv
COPY --from=builder /src/script/docker-entrypoint.sh /bin/entrypoint.sh

ENV PUID=1000 PGID=1000 HOME=/var/strelaysrv

HEALTHCHECK --interval=1m --timeout=10s \
  CMD nc -z localhost 22067 || exit 1

WORKDIR /var/strelaysrv
ENTRYPOINT ["/bin/entrypoint.sh", "/bin/strelaysrv"]