FROM node:12-slim

WORKDIR /testenv
COPY package.json .
RUN yarn install && yarn cache clean;

CMD node deploy.js

COPY . .