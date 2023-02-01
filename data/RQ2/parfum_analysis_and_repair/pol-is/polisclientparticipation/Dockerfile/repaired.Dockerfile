FROM node:10.15.0

RUN npm install -g gulp && npm cache clean --force;
RUN npm install -g bower && npm cache clean --force;
RUN npm install gulp && npm cache clean --force;
RUN npm link gulp

COPY package*.json ./
COPY bower.json ./
RUN npm install && npm cache clean --force;
RUN bower install --allow-root

ADD polis.config.template.js polis.config.js

ADD . .

RUN gulp prodBuildNoDeploy
