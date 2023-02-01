from node:12-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN apk update && apk add --no-cache bash

RUN yarn install && yarn cache clean;

COPY . .

RUN yarn add ./ && yarn cache clean;
