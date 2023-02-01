FROM node:14.17.5 AS builder
# Same base image
FROM builder as test
WORKDIR /app
COPY yarn.lock yarn.lock
COPY package.json package.json


RUN yarn --production=false; yarn cache clean;
COPY . /app

RUN yarn --production=false; yarn cache clean;


FROM builder as production

ENV NODE_ENV=production

WORKDIR /app
COPY yarn.lock yarn.lock
COPY package.json package.json

RUN yarn --production=false; yarn cache clean;

COPY . /app

RUN yarn --production=false; yarn cache clean; yarn build;
