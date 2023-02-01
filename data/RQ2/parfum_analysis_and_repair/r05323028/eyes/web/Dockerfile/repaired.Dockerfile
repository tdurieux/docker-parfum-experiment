FROM node:lts-buster

COPY . /app
RUN npm install -g serve && npm cache clean --force;

WORKDIR /app
RUN npm ci
RUN npm run build