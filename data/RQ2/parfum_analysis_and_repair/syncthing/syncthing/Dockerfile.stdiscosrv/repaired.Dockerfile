ARG GOVERSION=latest
FROM golang:$GOVERSION AS builder

WORKDIR /src
COPY . .

ENV CGO_ENABLED=0
ENV BUILD_HOST=syncthing.net
ENV BUILD_USER=docker
RUN rm -f stdiscosrv && go run build.go -no-upgrade build stdiscosrv

FROM alpine

EXPOSE 19200 8443

VOLUME ["/var/stdiscosrv"]

RUN apk add --no-cache ca-certificates su-exec

COPY --from=builder /src/stdiscosrv /bin/stdiscosrv
COPY --from=builder /src/script/docker-entrypoint.sh /bin/entrypoint.sh

ENV PUID=1000 PGID=1000 HOME=/var/stdiscosrv

HEALTHCHECK --interval=1m --timeout=10s \
  CMD nc -z localhost 8443 || exit 1

WORKDIR /var/stdiscosrv
ENTRYPOINT ["/bin/entrypoint.sh", "/bin/stdiscosrv"]