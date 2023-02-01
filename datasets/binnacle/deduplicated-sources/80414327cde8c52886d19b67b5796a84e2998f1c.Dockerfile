FROM node:10-alpine

# To handle 'not get uid/gid'
RUN npm config set unsafe-perm true

RUN npm install -g npm@6 && rm -rf ~app/.npm /tmp/*

RUN apk add --no-cache git make gcc g++

RUN addgroup -g 10001 app && \
    adduser -D -G app -h /app -u 10001 app
WORKDIR /app

USER app

COPY package.json package.json
COPY package-lock.json package-lock.json

RUN npm ci --production && rm -rf ~app/.npm /tmp/*

COPY . /app
USER root
RUN chown app:app /app/config

USER app
