FROM node:10

RUN npm install webpack -g && npm cache clean --force;
