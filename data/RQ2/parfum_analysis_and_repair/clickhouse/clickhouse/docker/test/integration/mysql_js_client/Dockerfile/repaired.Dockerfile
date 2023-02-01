# docker build -t clickhouse/mysql-js-client .
# MySQL JavaScript client docker container

FROM node:16.14.2

WORKDIR /usr/app

RUN npm install mysql && npm cache clean --force;

COPY ./test.js ./test.js
