FROM arm64v8/alpine:3.16@sha256:c3c58223e2af75154c4a7852d6924b4cc51a00c821553bbd9b3319481131b2e0 AS build
RUN apk add --no-cache ca-certificates mailcap

FROM scratch

EXPOSE 9000
ENTRYPOINT ["/usr/bin/prometheus-vcd-sd"]
CMD ["server"]
HEALTHCHECK CMD ["/usr/bin/prometheus-vcd-sd", "health"]

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /etc/mime.types /etc/

COPY bin/prometheus-vcd-sd /usr/bin/prometheus-vcd-sd