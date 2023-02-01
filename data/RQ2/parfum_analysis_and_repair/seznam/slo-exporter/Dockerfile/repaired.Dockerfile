FROM debian:stable-slim

RUN apt-get update && apt-get install --no-install-recommends ca-certificates -y && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY slo_exporter  /slo_exporter/
COPY Dockerfile /

WORKDIR /slo_exporter

ENTRYPOINT ["/slo_exporter/slo_exporter"]

CMD ["--help"]
