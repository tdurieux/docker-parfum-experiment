FROM node:8-alpine

LABEL maintainer "Archomeda (https://github.com/Archomeda/kormir-discord-bot)"

ENV NODE_ENV production

RUN mkdir /bot
WORKDIR /bot
COPY . /bot
RUN yarn install && yarn cache clean;

VOLUME /bot/config
CMD node server.js
