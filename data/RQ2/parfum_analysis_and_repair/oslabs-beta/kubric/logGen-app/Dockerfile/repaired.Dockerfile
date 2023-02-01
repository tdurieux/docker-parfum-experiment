FROM node:latest

COPY package*.json /usr/app/
COPY app/* /usr/app/

WORKDIR /usr/app

RUN npm install && npm cache clean --force;
CMD ["node","server.js"]