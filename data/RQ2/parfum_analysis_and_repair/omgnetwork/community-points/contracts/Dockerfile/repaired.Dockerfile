FROM node:12-alpine

RUN apk update && apk add --no-cache make git g++ python

COPY . /home/contracts

WORKDIR /home/contracts

RUN rm -Rf ./node_modules
RUN rm -Rf ./build

RUN npm install && npm cache clean --force;

RUN npx truffle version

RUN npx truffle compile
