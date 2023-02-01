FROM node:current-alpine AS builder

WORKDIR /src

COPY package.json package-lock.json ./

RUN npm install && npm cache clean --force;

COPY . .

RUN adduser --disabled-password --gecos '' web300vulnbackend
USER web300vulnbackend
ENTRYPOINT [ "node", "index.js"]