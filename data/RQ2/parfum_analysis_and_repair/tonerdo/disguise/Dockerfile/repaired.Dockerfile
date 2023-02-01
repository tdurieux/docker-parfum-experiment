FROM ubuntu:15.04
FROM node:latest

COPY . /app
WORKDIR /app

RUN npm install -g bower && npm cache clean --force;
RUN npm install && npm cache clean --force;
RUN bower --allow-root install
RUN npm install forever -g && npm cache clean --force;

EXPOSE 8080
EXPOSE 1025

ENTRYPOINT forever server.js