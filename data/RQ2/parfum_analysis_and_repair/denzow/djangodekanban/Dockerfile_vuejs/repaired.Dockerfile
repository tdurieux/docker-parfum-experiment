FROM node:10
MAINTAINER denzow <denzow@gmail.com>

RUN npm install -g @vue/cli @vue/cli-service-global && npm cache clean --force;

