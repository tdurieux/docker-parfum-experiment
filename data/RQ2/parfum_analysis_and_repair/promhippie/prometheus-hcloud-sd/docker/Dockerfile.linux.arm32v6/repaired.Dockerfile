FROM webhippie/alpine:latest@sha256:59f191a7e2ebdecb8728b40a8301f591e0ec6a801faae3276431753295fac781 AS build
RUN apk add --no-cache ca-certificates mailcap

FROM scratch

LABEL maintainer="Thomas Boerger <thomas@webhippie.de>" \
  org.label-schema.name="Prometheus Hetzner Cloud SD" \
  org.label-schema.vendor="Thomas Boerger" \
  org.label-schema.schema-version="1.0"

ENTRYPOINT ["/usr/bin/prometheus-hcloud-sd"]
CMD ["server"]
HEALTHCHECK CMD ["/usr/bin/prometheus-hcloud-sd", "health"]

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /etc/mime.types /etc/

COPY bin/prometheus-hcloud-sd /usr/bin/prometheus-hcloud-sd