FROM node:10

LABEL authors="giscafer <giscafer@outlook.com>"

WORKDIR /usr/src/app

COPY package.json package.json

RUN npm i && npm cache clean --force;

COPY . .

RUN npm run site:build
