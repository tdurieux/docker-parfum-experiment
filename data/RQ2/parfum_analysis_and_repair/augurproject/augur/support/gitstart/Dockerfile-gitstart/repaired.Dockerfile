ARG NODE_VERSION=12.18
FROM node:${NODE_VERSION}-alpine

RUN apk add --no-cache \
        bash \
        curl \
        g++ \
        gcc \
        git \
        libffi-dev \
        libstdc++ \
        linux-headers \
        make \
        musl-dev \
        openssl-dev \
        python-dev \
        python3-dev \
        supervisor \
        tmux

VOLUME ["/augur"]

WORKDIR /augur

RUN yarn