FROM node:15-alpine

LABEL maintainer="Leonardo Pliskieviski <leonardopliski@gmail.com>"

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY package.json package-lock.json ./
RUN npm i --legacy-peer-deps && npm cache clean --force;

COPY . .

EXPOSE 3000
