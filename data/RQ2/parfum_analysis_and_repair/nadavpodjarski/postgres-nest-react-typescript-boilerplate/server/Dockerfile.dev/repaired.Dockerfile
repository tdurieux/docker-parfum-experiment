FROM node:12-alpine

WORKDIR /app

COPY . /app

RUN npm install -g nodemon --silent && npm cache clean --force;
RUN npm install --silent && npm cache clean --force;
RUN apk add --no-cache bash

EXPOSE 5500