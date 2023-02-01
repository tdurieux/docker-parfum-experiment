FROM debian:stretch-slim

RUN apt-get update -y && apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*;

COPY logger.sh /
ENTRYPOINT ["/logger.sh"]
