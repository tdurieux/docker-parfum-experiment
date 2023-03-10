FROM arm64v8/alpine:3.12
LABEL maintainer="zhujian@caicloud.io"

RUN apk update && \
    apk add --no-cache ca-certificates bash coreutils git subversion curl jq

ENV DOCKER_VERSION=18.06.0
RUN curl -f -O https://download.docker.com/linux/static/stable/aarch64/docker-${DOCKER_VERSION}-ce.tgz && \
    tar -xzf docker-${DOCKER_VERSION}-ce.tgz && \
    mv docker/docker /usr/local/bin/docker && \
    rm -rf ./docker docker-${DOCKER_VERSION}-ce.tgz

RUN apk add --no-cache tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone


