FROM node:14.16-alpine as build-deps

RUN apk update && apk upgrade && \
  apk add --update git && \
  apk add --update openssh && \
  apk add --update bash && \
  apk add --update wget

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

COPY . .

COPY ./start.sh /start.sh
RUN chmod +x /start.sh

RUN npm run build
