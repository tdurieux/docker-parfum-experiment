FROM i386/alpine:3.16@sha256:72af6266bafde8c78d5f20a2a85d0576533ce1ecd6ed8bcf7baf62a743f3b24d AS build
RUN apk add --no-cache ca-certificates mailcap

FROM scratch

EXPOSE 9501
ENTRYPOINT ["/usr/bin/hcloud_exporter"]
HEALTHCHECK CMD ["/usr/bin/hcloud_exporter", "health"]

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /etc/mime.types /etc/

COPY bin/hcloud_exporter /usr/bin/hcloud_exporter