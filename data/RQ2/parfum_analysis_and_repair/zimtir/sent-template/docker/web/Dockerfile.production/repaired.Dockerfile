FROM node:lts-alpine

WORKDIR /var/www/web

COPY package.json .
COPY package-lock.json .

COPY __sapper__/build ./__sapper__/build
COPY public ./public

RUN npm install --production --no-optional && npm cache clean --force;

EXPOSE 3000
