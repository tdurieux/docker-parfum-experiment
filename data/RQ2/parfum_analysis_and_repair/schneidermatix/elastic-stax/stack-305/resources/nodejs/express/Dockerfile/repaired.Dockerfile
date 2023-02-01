FROM node:8

RUN mkdir -p /app
RUN npm install express && npm cache clean --force;

COPY app.js /app

WORKDIR /app
