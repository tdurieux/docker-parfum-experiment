FROM debian:buster-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ctorrent \
    && rm -rf /var/lib/apt/lists/*
COPY ./rootfs /
CMD ["/start"]
