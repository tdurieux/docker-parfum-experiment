FROM node:alpine

WORKDIR /app

COPY index.js index.js
COPY package.json package.json

RUN npm install && npm cache clean --force;

ENV PORT 3000

ENTRYPOINT [ "npm", "run", "start" ]
