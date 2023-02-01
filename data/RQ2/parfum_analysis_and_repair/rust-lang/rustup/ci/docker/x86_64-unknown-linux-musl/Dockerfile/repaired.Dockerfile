FROM ubuntu:18.04

COPY ci/docker/scripts/sccache.bash /scripts/

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -qy \
    musl-dev \
    musl-tools \
    curl \
    ca-certificates \
    perl \
    make \
    gcc && \
  bash /scripts/sccache.bash && rm -rf /var/lib/apt/lists/*;
