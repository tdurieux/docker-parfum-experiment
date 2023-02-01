FROM node:16-alpine

WORKDIR /server

COPY package*.json .

RUN npm i && npm cache clean --force;

COPY . .

CMD [ "node", "server.js" ]
