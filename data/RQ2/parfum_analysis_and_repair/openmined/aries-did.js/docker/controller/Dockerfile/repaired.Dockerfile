FROM node:10.15.3-alpine

WORKDIR /usr/src/app

ADD package*.json ./
ADD nodemon.json ./

ADD src ./src

RUN npm i && npm cache clean --force;
RUN npm install dotenv --global && npm cache clean --force;

USER node