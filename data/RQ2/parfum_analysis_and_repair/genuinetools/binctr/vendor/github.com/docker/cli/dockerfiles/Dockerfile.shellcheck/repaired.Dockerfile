FROM    debian:stretch-slim

RUN apt-get update && \
        apt-get -y --no-install-recommends install make shellcheck && \
        apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src/github.com/docker/cli
ENV     DISABLE_WARN_OUTSIDE_CONTAINER=1
CMD     bash
