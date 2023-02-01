FROM node:buster-slim as builder

WORKDIR /app

RUN apt-get update \
    && apt-get install --no-install-recommends -y git \
    && npm -g install gatsby-cli && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

COPY package*.json ./

RUN yarn

COPY . .
RUN mv scripts/* /usr/local/bin \
    && rm -rf scripts \
    && chmod +x /usr/local/bin/* \
    && rm -rf content/*

ONBUILD COPY . /app
ONBUILD RUN builder.sh
