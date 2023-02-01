FROM node:4

RUN npm install -g yarn && npm cache clean --force;
