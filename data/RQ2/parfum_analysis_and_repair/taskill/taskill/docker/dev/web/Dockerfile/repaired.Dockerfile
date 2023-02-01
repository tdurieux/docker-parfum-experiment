FROM node:latest
WORKDIR /usr/src/app
COPY /client/package*.json ./
RUN npm install && npm cache clean --force;
COPY /client .