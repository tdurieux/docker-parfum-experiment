FROM node:13.10-alpine

COPY lib/ lib/
COPY app.js .
COPY package.json .

RUN apk update && apk add --no-cache python make g++ gcc
RUN npm install && npm cache clean --force;
EXPOSE 8080
CMD node app.js
