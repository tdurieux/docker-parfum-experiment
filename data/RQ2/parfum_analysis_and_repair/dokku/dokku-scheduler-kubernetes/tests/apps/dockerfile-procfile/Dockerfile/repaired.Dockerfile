FROM node:4-alpine

RUN apk add --no-cache bash

COPY . /app
WORKDIR /app
RUN npm install && npm cache clean --force;

CMD npm start
