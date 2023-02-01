FROM node:8.9-alpine

RUN apk add --no-cache make gcc g++ python git bash

RUN npm install -g typescript && npm cache clean --force;
RUN npm install -g typeorm && npm cache clean --force;

EXPOSE 3000