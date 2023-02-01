FROM node:14-buster-slim

RUN true \
      && npm install -g typescript && npm cache clean --force;
