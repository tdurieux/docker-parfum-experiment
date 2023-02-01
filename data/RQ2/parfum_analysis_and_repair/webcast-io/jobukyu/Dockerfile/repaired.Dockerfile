FROM node:0.10-onbuild

MAINTAINER Axisto Media

ENV NODE_ENV docker

ADD ./ /jobukyu
WORKDIR /jobukyu

RUN cp config.example.js config.js

RUN npm install && npm cache clean --force;

EXPOSE 3800
