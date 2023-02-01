FROM debian:stretch-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -yqq stress-ng && \
    rm -rf /var/cache/apt && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

