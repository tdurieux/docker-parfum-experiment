FROM ubuntu:18.04
LABEL maintainer="james@example.com"
ENV REFRESHED_AT 2015-07-20

RUN apt-get update && apt-get -y --no-install-recommends install redis-tools && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/usr/bin/redis-cli"]
CMD []
