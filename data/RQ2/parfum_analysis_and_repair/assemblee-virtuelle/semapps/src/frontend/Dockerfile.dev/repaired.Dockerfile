FROM node:13.14-alpine

WORKDIR /app

RUN apk add --update --no-cache git bash yarn nano

RUN apk add --update --no-cache autoconf libtool automake alpine-sdk

CMD npm install && npm start