FROM node:latest

RUN npm i -g nodemon node-inspector npm-run-all rimraf && npm cache clean --force;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/package.json
RUN npm install && npm cache clean --force;

COPY . /usr/src/app
