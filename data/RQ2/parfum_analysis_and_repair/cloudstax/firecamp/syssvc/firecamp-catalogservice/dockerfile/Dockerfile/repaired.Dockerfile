FROM debian:jessie-slim

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /var/log/firecamp

COPY firecamp-catalogservice /
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 27040
