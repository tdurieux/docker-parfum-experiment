FROM node:14.5.0-alpine
EXPOSE 3000

RUN mkdir /app
WORKDIR /app

RUN apk update && apk add --no-cache bash
RUN apk add --no-cache git

ENV PATH /app/node_modules/.bin:$PATH
ENV NODE_ENV mainnet

COPY package.json package-lock.json /app/

RUN npm i && npm cache clean --force;

COPY . /app/

RUN npm run build
RUN npm install -g serve && npm cache clean --force;

RUN apk add --no-cache tar

RUN tar cfz ethhmy-bridge-fe.tgz build
