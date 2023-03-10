ARG VERSION=lts

FROM node:$VERSION-bullseye

LABEL maintainer="Renoki Co. <alex@renoki.org>"

ENV PYTHONUNBUFFERED=1

COPY . /tmp/build

WORKDIR /tmp/build

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y git python3 gcc wget && \
    bash ./build-minimal-production && \
    mkdir -p /app && \
    cd /tmp/build && \
    mv production-app/* /app/ && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

EXPOSE 6001

ENTRYPOINT ["node", "/app/bin/server.js", "start"]
