FROM node:latest

RUN npm install -g yarn && npm cache clean --force;

WORKDIR /app
CMD yarn run watch
