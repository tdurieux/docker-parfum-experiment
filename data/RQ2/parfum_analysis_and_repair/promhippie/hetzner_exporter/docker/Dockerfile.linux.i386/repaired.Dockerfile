FROM webhippie/alpine:latest-amd64@sha256:cf9f805729975a07489df76d012a07401cd0bcad7603456f003c0f35371d3e2b AS build
RUN apk add --no-cache ca-certificates mailcap

FROM scratch

LABEL maintainer="Thomas Boerger <thomas@webhippie.de>" \
  org.opencontainers.image.title="Hetzner Exporter" \
  org.opencontainers.image.documentation="https://promhippie.github.io/hetzner_exporter/" \
  org.opencontainers.image.vendor="Thomas Boerger"

EXPOSE 9502
ENTRYPOINT ["/usr/bin/hetzner_exporter"]
HEALTHCHECK CMD ["/usr/bin/hetzner_exporter", "health"]

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /etc/mime.types /etc/

COPY bin/hetzner_exporter /usr/bin/hetzner_exporter