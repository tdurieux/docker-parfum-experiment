FROM node:14-alpine as build-deps

RUN apk update && apk upgrade && \
  apk add --no-cache --update git && \
  apk add --no-cache --update openssh && \
  apk add --no-cache --update bash && \
  apk add --no-cache --update wget

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .
