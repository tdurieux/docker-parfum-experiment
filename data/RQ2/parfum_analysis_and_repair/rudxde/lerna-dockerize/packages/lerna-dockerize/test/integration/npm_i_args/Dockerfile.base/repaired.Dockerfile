FROM node:16 as base
COPY ./package.json ./
RUN npm install && npm cache clean --force;
