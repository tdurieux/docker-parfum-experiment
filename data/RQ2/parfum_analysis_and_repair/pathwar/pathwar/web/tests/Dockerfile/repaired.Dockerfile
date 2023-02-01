FROM node:11-stretch

WORKDIR /app

COPY ./package*.json ./
RUN npm install && npm cache clean --force;
COPY ./ ./
