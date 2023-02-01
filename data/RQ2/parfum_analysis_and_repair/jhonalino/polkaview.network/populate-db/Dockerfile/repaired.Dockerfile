FROM node:lts-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

ENTRYPOINT [ "node", "index" ]
