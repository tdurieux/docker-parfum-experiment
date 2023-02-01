FROM node:14-slim

WORKDIR /usr/src/codecrumbs

COPY package*.json ./

RUN yarn install && yarn cache clean;

COPY . .

EXPOSE 2018 3018
