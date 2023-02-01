FROM node:9-alpine

RUN apk update && \
 apk add --no-cache git make gcc g++ python


RUN npm install -g mocha && npm cache clean --force;
RUN npm install -g sails && npm cache clean --force;
RUN npm install -g bower && npm cache clean --force;
RUN npm install -g grunt && npm cache clean --force;
RUN npm install -g grunt-cli && npm cache clean --force;

WORKDIR /usr/src/app

EXPOSE 1337
EXPOSE 35732