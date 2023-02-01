FROM node:16

WORKDIR /app

COPY . /app

RUN npm install && npm cache clean --force;
