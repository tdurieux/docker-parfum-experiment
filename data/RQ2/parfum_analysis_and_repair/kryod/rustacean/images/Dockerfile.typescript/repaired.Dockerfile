FROM node:latest

RUN npm install -g typescript && npm cache clean --force;