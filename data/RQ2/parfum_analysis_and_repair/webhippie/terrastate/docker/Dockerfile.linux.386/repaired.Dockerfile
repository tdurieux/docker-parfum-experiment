FROM i386/alpine:3.16@sha256:72af6266bafde8c78d5f20a2a85d0576533ce1ecd6ed8bcf7baf62a743f3b24d AS build
RUN apk add --no-cache ca-certificates mailcap

FROM scratch

EXPOSE 8080 8081
VOLUME ["/var/lib/terrastate"]
ENTRYPOINT ["/usr/bin/terrastate"]
CMD ["server"]

ENV TERRASTATE_STORAGE /var/lib/terrastate

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /etc/mime.types /etc/

COPY bin/terrastate /usr/bin/terrastate