FROM node:14.7.0-alpine3.12

RUN npm install -g typescript && npm cache clean --force;
RUN npm link typescript

WORKDIR /app
