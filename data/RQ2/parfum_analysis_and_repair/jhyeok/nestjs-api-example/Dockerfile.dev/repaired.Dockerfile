FROM node:16.13.0-alpine AS builder

COPY . /app
WORKDIR /app

RUN yarn install && yarn build && yarn cache clean;

FROM node:16.13.0-alpine

ARG PROJECT_DIR=/usr/src/app

COPY --from=builder /app $PROJECT_DIR

WORKDIR $PROJECT_DIR

RUN apk add --no-cache --update bash

ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /
RUN chmod +x /wait-for-it.sh
