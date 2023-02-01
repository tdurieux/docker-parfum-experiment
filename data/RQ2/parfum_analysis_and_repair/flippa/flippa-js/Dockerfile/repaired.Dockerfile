FROM node:6.9.1-alpine

ADD package.json /src/

WORKDIR /src

RUN npm install && npm cache clean --force;

ADD . /src
