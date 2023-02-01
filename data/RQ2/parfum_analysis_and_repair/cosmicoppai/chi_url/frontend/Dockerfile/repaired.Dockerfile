FROM node:16.8.0-slim

WORKDIR /frontend

COPY package.json ./

RUN npm config set registry https://registry.npmjs.com/

RUN npm install && npm cache clean --force;

COPY . ./

RUN npm run build