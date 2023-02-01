FROM debian:jessie-slim

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY firecamp-initcontainer /
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
