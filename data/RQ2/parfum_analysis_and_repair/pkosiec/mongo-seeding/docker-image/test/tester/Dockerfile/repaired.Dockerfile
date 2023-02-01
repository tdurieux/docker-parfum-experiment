FROM node:15-alpine

WORKDIR /app

COPY ./package.json ./package-lock.json /app/

RUN npm install --no-optional && npm cache clean --force;

COPY ./src /app/src

ENV CI true

CMD npm test