FROM node:12-alpine

ENV SUPPORTING_FILES /app
ARG DEV

# install bash for wait-for-it script
RUN apk update && apk add --no-cache --update alpine-sdk build-base bash python nano postgresql-client

RUN mkdir -p $SUPPORTING_FILES
RUN mkdir -p /node_modules

WORKDIR $SUPPORTING_FILES

ADD package.json .

RUN npm install && npm cache clean --force;

COPY . $SUPPORTING_FILES

RUN npm run test

RUN npm run build