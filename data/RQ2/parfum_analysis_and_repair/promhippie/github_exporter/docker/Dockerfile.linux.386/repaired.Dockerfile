FROM i386/alpine:3.16@sha256:72af6266bafde8c78d5f20a2a85d0576533ce1ecd6ed8bcf7baf62a743f3b24d AS build
RUN apk add --no-cache ca-certificates mailcap

FROM scratch

EXPOSE 9504
ENTRYPOINT ["/usr/bin/github_exporter"]
HEALTHCHECK CMD ["/usr/bin/github_exporter", "health"]

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /etc/mime.types /etc/

COPY bin/github_exporter /usr/bin/github_exporter