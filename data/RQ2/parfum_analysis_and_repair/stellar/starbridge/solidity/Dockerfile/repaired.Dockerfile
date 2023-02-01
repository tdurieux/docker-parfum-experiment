FROM node:16-alpine

COPY . /usr/src/app

WORKDIR /usr/src/app

RUN apk add --no-cache git;

RUN npm ci

RUN npx hardhat compile