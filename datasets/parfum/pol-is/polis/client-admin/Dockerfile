# Gulp v3 stops us from upgrading beyond Node v11
FROM docker.io/node:11.15.0-alpine

WORKDIR /app

RUN apk add git --no-cache

COPY package*.json ./
RUN npm install

COPY polis.config.template.js polis.config.js
# If polis.config.js exists on host, will override template here.
COPY . .

ARG GIT_HASH
RUN npm run deploy:prod
