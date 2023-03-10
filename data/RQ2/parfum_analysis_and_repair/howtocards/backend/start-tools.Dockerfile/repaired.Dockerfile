FROM debian:9-slim

RUN seq 1 8 | xargs -I{} mkdir -p /usr/share/man/man{} && \
    apt update && \
    apt -y --no-install-recommends install libpq-dev postgresql-client && \
    apt clean && rm -rf /var/lib/apt/lists/*;
