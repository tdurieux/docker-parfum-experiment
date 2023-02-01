FROM debian:stretch-slim

RUN apt-get update && apt-get install --no-install-recommends -y netcat-openbsd && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "nc" ]
