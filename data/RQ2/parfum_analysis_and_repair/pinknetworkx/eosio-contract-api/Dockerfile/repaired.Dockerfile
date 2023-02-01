FROM node:16-alpine

RUN adduser --disabled-password application && \
  mkdir -p /home/application/app/ && \
  chown -R application:application /home/application

USER application

WORKDIR /home/application/app

COPY yarn.lock .
COPY package.json .

RUN yarn install --ignore-scripts && yarn cache clean;

COPY . .

RUN yarn install && yarn cache clean;

ENV NODE_ENV production
EXPOSE 9000
