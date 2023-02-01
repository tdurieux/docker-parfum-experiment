FROM        node:latest

RUN npm install -g npm-check-updates && npm cache clean --force;

WORKDIR     /app

ENTRYPOINT  ["npm-check-updates"]
