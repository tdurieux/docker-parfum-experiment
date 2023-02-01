FROM node:6.9

RUN npm install -g gulp && npm cache clean --force;
