FROM node:12.12.0-alpine

WORKDIR /home/app/api

ENV PATH /home/app/api/node_modules/.bin:$PATH

COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .

EXPOSE 3001