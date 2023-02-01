FROM node:10

WORKDIR /

COPY . /cryptoverse

WORKDIR /cryptoverse

RUN yarn install --pure-lockfile && yarn cache clean;

RUN yarn build

WORKDIR /
