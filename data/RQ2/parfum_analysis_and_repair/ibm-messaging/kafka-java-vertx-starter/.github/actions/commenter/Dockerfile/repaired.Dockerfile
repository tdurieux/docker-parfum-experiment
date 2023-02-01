FROM node:slim

COPY index.js .
COPY package.json .
COPY package-lock.json .

RUN npm install && npm cache clean --force;

ENTRYPOINT ["node", "/index.js"];
