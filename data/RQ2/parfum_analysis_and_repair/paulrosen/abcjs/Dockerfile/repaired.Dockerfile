FROM node:18.3.0

RUN npm install -g npm@8.13.2 && npm cache clean --force;

RUN mkdir /srv/app && chown node:node /srv/app

USER node

WORKDIR /srv/app
