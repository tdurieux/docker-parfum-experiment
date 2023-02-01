FROM node:12.14.1-alpine

WORKDIR /home/node

COPY package.json .

RUN npm install && npm cache clean --force;
ENV PATH /home/node/node_modules/.bin:$PATH

WORKDIR /home/node/app
