# Docker image for orchestrator
# The base image is pinned to the debug-nonroot tag
FROM gcr.io/distroless/base-debian11@sha256:e76722f06f7c15e0076072fb02782ec59923b0d658b8a3d80bb79deaee6fb44d
SHELL ["/busybox/sh", "-c"]

# switch to root for installing software
USER root

RUN set -ex \
    && mkdir -p /usr/local/bin \
    && export DOCKERIZE_VERSION=0.6.1 \
    && wget https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz -O- | \
        tar -C /usr/local/bin -xzv

RUN set -ex \
    && export ORCHESTRATOR_VERSION=3.2.3 \
    && wget https://github.com/openark/orchestrator/releases/download/v${ORCHESTRATOR_VERSION}/orchestrator-${ORCHESTRATOR_VERSION}-linux-amd64.tar.gz -O- | \
        tar -C / -xzv

COPY rootfs/ /
RUN set -ex \
    && mkdir -p /etc/orchestrator /var/lib/orchestrator \
    && chown -R 65532:65532 /etc/orchestrator /var/lib/orchestrator

# switch back to nonroot for runtime