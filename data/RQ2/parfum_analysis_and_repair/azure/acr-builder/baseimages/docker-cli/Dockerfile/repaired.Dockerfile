# Required.
# docker build -f baseimages/docker-cli/Dockerfile -t docker .
ARG DOCKER_CLI_BASE_IMAGE=mcr.microsoft.com/acr/moby-cli:linux-latest
FROM ${DOCKER_CLI_BASE_IMAGE}

ARG GIT_LFS_VERSION=2.5.2
# disable prompt asking for credential