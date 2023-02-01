# This Docker image is used only for local testing and not by the CI-based releases.
FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install --no-install-recommends docker.io -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends jq -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;

COPY bin /usr/local/bin

VOLUME ["/var/run/docker.sock"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
