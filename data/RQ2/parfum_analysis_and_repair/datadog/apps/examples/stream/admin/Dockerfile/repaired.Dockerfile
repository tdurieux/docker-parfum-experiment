FROM node:16.13-buster-slim

ADD . /admin
WORKDIR /admin

RUN yarn && yarn cache clean;

