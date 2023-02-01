FROM node:12.6-alpine

RUN apk add --update --no-cache bash make
RUN npm install katacoda-cli -g && npm cache clean --force;

WORKDIR /app
