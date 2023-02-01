FROM node:14-alpine

WORKDIR /usr/src/cli

COPY package.json ./
COPY yarn.lock ./
COPY src ./src
COPY bin ./bin

RUN yarn install && yarn cache clean;

WORKDIR /usr/src/app

ENTRYPOINT ["../cli/bin/run"]
