FROM amd64/alpine:3.16@sha256:4ff3ca91275773af45cb4b0834e12b7eb47d1c18f770a0b151381cd227f4c253 AS build
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