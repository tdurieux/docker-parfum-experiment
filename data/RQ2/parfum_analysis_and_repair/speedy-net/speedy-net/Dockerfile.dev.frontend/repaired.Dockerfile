FROM node:8-alpine

#RUN apk update
#RUN apk add git

RUN mkdir /app
WORKDIR /app

ADD package-lock.json /app
ADD package.json /app
ADD gulpfile.js /app

ADD themes /app/themes
ADD speedy/core/static/themes /app/speedy/core/static/themes

RUN npm install && npm cache clean --force;
