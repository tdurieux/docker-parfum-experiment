FROM node:14-alpine

MAINTAINER Ferdinand Mütsch <ferdinand@muetsch.io>

WORKDIR /app

ARG base_url=/
ENV BASE_URL $base_url

COPY . /app/

VOLUME ["/app/data"]

RUN cd /app && yarn && yarn cache clean;

RUN cd /app/webapp && \
    yarn && \
    yarn build:base && \
    cd .. && yarn cache clean;

ENTRYPOINT yarn start
