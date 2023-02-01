FROM node:slim

COPY . /action
WORKDIR /action

RUN npm install --production && npm cache clean --force;

ENTRYPOINT ["node", "/action/main.js"]
