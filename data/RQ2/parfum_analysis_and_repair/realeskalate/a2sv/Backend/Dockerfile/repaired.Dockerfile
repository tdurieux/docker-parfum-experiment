From node:13-slim

WORKDIR /api


ADD . /api

RUN npm install && npm cache clean --force;
CMD node index.js