FROM docker:20.10-dind@sha256:6dd895238f055a79a6d044f7d97b668bef0f9a840e5eed06fa01f1a6b7aed17e

LABEL maintainer="Robert Kaussow <mail@thegeeklab.de>"
LABEL org.opencontainers.image.authors="Robert Kaussow <mail@thegeeklab.de>"
LABEL org.opencontainers.image.title="drone-docker-buildx"
LABEL org.opencontainers.image.url="https://github.com/thegeeklab/drone-docker-buildx"
LABEL org.opencontainers.image.source="https://github.com/thegeeklab/drone-docker-buildx"
LABEL org.opencontainers.image.documentation="https://github.com/thegeeklab/drone-docker-buildx"

ARG BUILDX_VERSION

# renovate: datasource=github-releases depName=docker/buildx
ENV BUILDX_VERSION="${BUILDX_VERSION:-v0.8.2}"

ENV DOCKER_HOST=unix:///var/run/docker.sock

RUN apk --update add --virtual .build-deps curl && \
    mkdir -p /usr/lib/docker/cli-plugins/ && \
    curl -f -SsL -o /usr/lib/docker/cli-plugins/docker-buildx "https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION##v}/buildx-v${BUILDX_VERSION##v}.linux-amd64" && \
    chmod 755 /usr/lib/docker/cli-plugins/docker-buildx && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

ADD dist/drone-docker-buildx /bin/

ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh", "drone-docker-buildx"]
