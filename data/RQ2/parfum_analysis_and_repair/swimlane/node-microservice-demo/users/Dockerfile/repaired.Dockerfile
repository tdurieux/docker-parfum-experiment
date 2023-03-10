FROM node:latest

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/package.json
RUN npm install && npm cache clean --force;

COPY . /usr/src/app