FROM node:10

WORKDIR /app

COPY package.json /app

RUN npm install && npm cache clean --force;

COPY . /app

CMD nodejs index.js

EXPOSE 30001
