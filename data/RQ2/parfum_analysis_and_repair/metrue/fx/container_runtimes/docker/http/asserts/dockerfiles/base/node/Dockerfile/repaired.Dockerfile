FROM node:alpine

COPY . .
RUN npm install && npm cache clean --force;
