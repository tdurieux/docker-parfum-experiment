FROM node:12

COPY . /app

WORKDIR /app

RUN yarn && yarn cache clean;
