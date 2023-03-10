FROM node:alpine

RUN apk add --no-cache --update yarn

COPY . /opt/app

WORKDIR /opt/app

RUN yarn

EXPOSE 3000

ENTRYPOINT yarn start:prod