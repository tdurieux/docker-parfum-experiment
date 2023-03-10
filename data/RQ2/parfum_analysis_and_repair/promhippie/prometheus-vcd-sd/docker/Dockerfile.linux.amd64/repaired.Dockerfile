FROM amd64/alpine:3.16@sha256:4ff3ca91275773af45cb4b0834e12b7eb47d1c18f770a0b151381cd227f4c253 AS build
RUN apk add --no-cache ca-certificates mailcap

FROM scratch

EXPOSE 9000
ENTRYPOINT ["/usr/bin/prometheus-vcd-sd"]
CMD ["server"]
HEALTHCHECK CMD ["/usr/bin/prometheus-vcd-sd", "health"]

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /etc/mime.types /etc/

COPY bin/prometheus-vcd-sd /usr/bin/prometheus-vcd-sd