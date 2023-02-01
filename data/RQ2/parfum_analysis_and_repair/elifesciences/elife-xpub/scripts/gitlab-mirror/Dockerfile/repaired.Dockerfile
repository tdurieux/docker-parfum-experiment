FROM ubuntu:latest

RUN \
  apt-get update \
  && apt-get install --no-install-recommends -y git curl && rm -rf /var/lib/apt/lists/*;

COPY mirror /usr/bin/mirror

ENTRYPOINT ["mirror"]
