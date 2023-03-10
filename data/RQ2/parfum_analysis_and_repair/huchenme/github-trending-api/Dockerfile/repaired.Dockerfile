FROM node:12-alpine

RUN mkdir /root/github-trending-api
COPY . /root/github-trending-api
WORKDIR /root/github-trending-api

RUN yarn && yarn cache clean;
CMD yarn start

