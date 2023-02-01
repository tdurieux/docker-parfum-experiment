FROM node:16

WORKDIR /usr/src/lichess-gui-use-code-example/Extension (drag this folder into Chrome)

COPY package*.json ./

RUN npm install && npm cache clean --force;
