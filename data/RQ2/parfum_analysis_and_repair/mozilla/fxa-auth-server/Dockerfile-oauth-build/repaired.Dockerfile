FROM node:10-alpine AS builder

RUN npm install -g npm@6 && rm -rf ~app/.npm /tmp/* && npm cache clean --force;

RUN apk add --no-cache git linux-headers openssl && \
    apk add --repository http://dl-cdn.alpinelinux.org/alpine/v3.5/community/ --no-cache --virtual .build-deps git python make g++

RUN addgroup -g 10001 app && \
    adduser -D -G app -h /app -u 10001 app
WORKDIR /app

# S3 bucket in Cloud Services prod IAM
ADD https://s3.amazonaws.com/dumb-init-dist/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

USER app

COPY npm-shrinkwrap.json npm-shrinkwrap.json
COPY package.json package.json
COPY scripts/download_l10n.sh scripts/download_l10n.sh
COPY fxa-oauth-server/scripts/gen_keys.js fxa-oauth-server/scripts/gen_keys.js

RUN npm install --production && rm -rf ~app/.npm /tmp/* && npm cache clean --force;

COPY . /app


# Build final image by copying from builder
FROM node:10-alpine

RUN npm install -g npm@6 && rm -rf ~app/.npm /tmp/* && npm cache clean --force;

RUN apk add --no-cache git make gcc g++ linux-headers openssl python

RUN addgroup -g 10001 app && \
    adduser -D -G app -h /app -u 10001 app
WORKDIR /app

# S3 bucket in Cloud Services prod IAM
ADD https://s3.amazonaws.com/dumb-init-dist/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

USER app

COPY --from=builder --chown=app /app/ /app/

RUN node fxa-oauth-server/scripts/gen_keys.js
