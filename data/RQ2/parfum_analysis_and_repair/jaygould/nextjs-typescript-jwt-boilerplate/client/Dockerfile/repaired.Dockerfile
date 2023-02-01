FROM node:14.4.0-alpine

WORKDIR /home/app/client

ENV PATH /home/app/client/node_modules/.bin:$PATH

COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .

EXPOSE 3000