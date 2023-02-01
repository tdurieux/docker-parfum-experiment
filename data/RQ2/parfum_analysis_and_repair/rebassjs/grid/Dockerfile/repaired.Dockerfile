FROM node:10-alpine

WORKDIR /usr/src

COPY package.json .
COPY package-lock.json .
RUN npm i && npm cache clean --force;

COPY . .
RUN npm run build && mv site /public
