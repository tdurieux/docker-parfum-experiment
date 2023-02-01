# Telepat.io API image
#
# VERSION 0.2.3

FROM node:4.8.3
MAINTAINER Andrei Marinescu <andrei@telepat.io>

RUN mkdir /app

COPY . /app
WORKDIR /app
RUN npm install && npm cache clean --force;

# install nodemon
RUN npm install --global nodemon && npm cache clean --force;

WORKDIR /app

EXPOSE 3000
