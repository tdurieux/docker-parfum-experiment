FROM node:8.16.2-slim

WORKDIR /app

COPY . /app

RUN npm install && npm cache clean --force;

CMD ['node', 'app.js']
