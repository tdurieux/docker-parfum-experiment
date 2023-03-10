FROM golang:1.18 AS certs

FROM scratch
ARG TARGETOS TARGETARCH
ENV GODEBUG=netdns=go
ENV WOODPECKER_DATABASE_DATASOURCE=/var/lib/woodpecker/woodpecker.sqlite
ENV WOODPECKER_DATABASE_DRIVER=sqlite3
ENV XDG_CACHE_HOME=/var/lib/woodpecker
EXPOSE 8000 9000 80 443

# copy certs from golang:1.18 image
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
# copy server binary
COPY dist/server/${TARGETOS}/${TARGETARCH}/woodpecker-server /bin/

ENTRYPOINT ["/bin/woodpecker-server"]