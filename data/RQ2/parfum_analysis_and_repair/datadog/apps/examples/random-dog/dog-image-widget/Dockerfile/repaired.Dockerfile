FROM node:16.13-buster-slim

ADD . /app
WORKDIR /app

RUN yarn && yarn cache clean;

