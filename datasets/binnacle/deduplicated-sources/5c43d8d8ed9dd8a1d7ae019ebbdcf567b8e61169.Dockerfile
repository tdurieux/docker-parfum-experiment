ARG DOCKER_VERSION=latest
FROM docker:${DOCKER_VERSION}

ARG COMPOSE_VERSION=
ARG DOCKER_VERSION

RUN apk add --no-cache py-pip python-dev libffi-dev openssl-dev gcc libc-dev make
RUN pip install "docker-compose${COMPOSE_VERSION:+==}${COMPOSE_VERSION}"

LABEL \
  org.opencontainers.image.authors="Tobias Maier <tobias.maier@baucloud.com>" \
  org.opencontainers.image.description="This docker image installs docker-compose on top of the docker image." \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/tmaier/docker-compose" \
  org.opencontainers.image.title="Docker Compose on docker base image" \
  org.opencontainers.image.vendor="BauCloud GmbH" \
  org.opencontainers.image.version="${DOCKER_VERSION} with docker-compose ${COMPOSE_VERSION}"
