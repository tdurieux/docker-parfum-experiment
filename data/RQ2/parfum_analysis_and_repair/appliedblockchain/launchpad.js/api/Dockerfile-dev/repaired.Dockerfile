FROM node:10.16.2-alpine

RUN apk --update --no-cache add alpine-sdk git python openssl curl bash && \
  rm -rf /tmp/* /var/cache/apk/*

RUN npm i -g pm2 && npm cache clean --force;

USER node

RUN mkdir /home/node/api

WORKDIR /home/node/api

COPY package.json package.json

ARG NPM_TOKEN

RUN echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > ~/.npmrc &&\
  npm i && \
  rm ~/.npmrc && npm cache clean --force;

COPY . /home/node/api

EXPOSE 3000

CMD pm2 start run.js --watch . && pm2 logs
