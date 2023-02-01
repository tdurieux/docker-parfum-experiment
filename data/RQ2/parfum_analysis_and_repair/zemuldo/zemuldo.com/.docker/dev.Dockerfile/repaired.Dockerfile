FROM node:alpine

WORKDIR /usr/src/app

RUN apk add --no-cache inotify-tools

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3001 3002
