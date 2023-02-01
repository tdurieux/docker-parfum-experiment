FROM node:alpine
WORKDIR /usr/src/app

ENV docker docker

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

CMD [ "node", "index.js" ]
