FROM node:16.14.2

WORKDIR /opt/sc/frontend

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . ./


