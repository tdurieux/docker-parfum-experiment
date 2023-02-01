FROM node:16.14-alpine

COPY . /app
WORKDIR /app

RUN yarn && yarn cache clean;

CMD yarn dev
