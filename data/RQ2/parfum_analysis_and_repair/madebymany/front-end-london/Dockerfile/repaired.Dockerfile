FROM node:10.16.3-alpine

RUN apk add --no-cache build-base gcc autoconf automake libtool zlib-dev libpng-dev nasm
RUN npm install -g gatsby-cli && npm cache clean --force;

WORKDIR /app
COPY package.json .
COPY package-lock.json .
RUN npm install && npm cache clean --force;
COPY . .
