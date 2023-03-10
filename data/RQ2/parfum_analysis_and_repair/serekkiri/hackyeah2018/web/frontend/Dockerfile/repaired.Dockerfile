FROM node:alpine

WORKDIR /usr/app

COPY package.json .
RUN npm install --quiet && npm cache clean --force;

COPY . .