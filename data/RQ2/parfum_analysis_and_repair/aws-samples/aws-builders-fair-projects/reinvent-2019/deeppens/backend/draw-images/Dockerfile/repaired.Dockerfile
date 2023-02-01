FROM node:10-slim

COPY package*.json ./

RUN npm install && npm cache clean --force;
WORKDIR /usr/src/app

USER root

EXPOSE 8080
COPY . .
CMD [ "npm", "start" ]
