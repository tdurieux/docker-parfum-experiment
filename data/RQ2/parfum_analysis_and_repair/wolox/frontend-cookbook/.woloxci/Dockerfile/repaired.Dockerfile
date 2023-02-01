FROM node:10.15.3-alpine

USER node

WORKDIR /home/node

COPY ./app/package.json .

RUN npm install && npm cache clean --force;

ENV PATH /home/node/node_modules/.bin:$PATH

WORKDIR /home/node/app
