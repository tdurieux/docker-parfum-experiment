FROM debian:stretch-slim

RUN apt-get update && apt-get install --no-install-recommends -y --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" openssl ca-certificates && rm -rf /var/lib/apt/lists/*;
COPY hone /usr/bin/hone

ENTRYPOINT ["/usr/bin/hone"]
