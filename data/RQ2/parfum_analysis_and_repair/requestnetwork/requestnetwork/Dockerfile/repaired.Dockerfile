FROM node:16-alpine

WORKDIR /app

RUN apk add --no-cache --virtual .build-deps git python g++ bash make

COPY package.json .
COPY yarn.lock .

RUN yarn

COPY . .
RUN yarn
RUN yarn build

RUN apk del .build-deps
