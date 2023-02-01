FROM node:12.9.1-alpine

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app/

COPY package.json /usr/src/app/
COPY yarn.lock /usr/src/app/

RUN yarn install && yarn cache clean;

COPY . /usr/src/app/
