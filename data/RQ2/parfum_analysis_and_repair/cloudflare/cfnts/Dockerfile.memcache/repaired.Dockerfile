FROM debian:stretch

RUN apt-get update && \
    apt-get -y --no-install-recommends install memcached python-pip && \
    pip install --no-cache-dir python-memcached && rm -rf /var/lib/apt/lists/*;

COPY scripts/ scripts/
CMD ["./scripts/run_memcached.sh"]
