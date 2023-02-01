FROM debian:stable-slim

RUN apt-get update && apt-get install --no-install-recommends iproute2 -y && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/sbin/tc"]