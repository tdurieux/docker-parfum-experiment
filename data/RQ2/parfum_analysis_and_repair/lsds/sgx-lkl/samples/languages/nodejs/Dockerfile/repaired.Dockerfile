FROM alpine:3.8

RUN apk add --no-cache \
    nodejs npm

RUN npm i cpu-benchmark && npm cache clean --force;

ADD app /app
