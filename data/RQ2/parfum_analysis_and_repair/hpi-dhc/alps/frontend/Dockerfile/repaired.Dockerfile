FROM node:12-alpine

RUN mkdir /app
WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

COPY package.json yarn.lock /app/
RUN yarn install && yarn cache clean;

COPY . /app
