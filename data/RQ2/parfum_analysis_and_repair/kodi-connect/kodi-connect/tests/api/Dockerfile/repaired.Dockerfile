FROM node:10
ARG VERSION

RUN yarn global add jest && yarn cache clean;

USER node

RUN mkdir -p /home/node/app

WORKDIR /home/node/app

RUN yarn add axios mongodb bcryptjs && yarn cache clean;
