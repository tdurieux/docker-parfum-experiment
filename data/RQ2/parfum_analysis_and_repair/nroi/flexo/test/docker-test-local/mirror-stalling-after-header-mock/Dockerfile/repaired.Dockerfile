FROM debian:buster-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends netcat-openbsd && rm -rf /var/lib/apt/lists/*;

COPY header /root/header
COPY send-header-only /usr/bin/send-header-only

ENTRYPOINT ["/usr/bin/send-header-only"]
