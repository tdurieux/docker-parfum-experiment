FROM node:latest

MAINTAINER yedincisenol

RUN npm install newman -g && npm cache clean --force;

WORKDIR /var/www/api