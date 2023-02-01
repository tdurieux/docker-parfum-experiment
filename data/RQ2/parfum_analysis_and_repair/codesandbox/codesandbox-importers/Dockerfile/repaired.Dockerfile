FROM node:14.13.1
MAINTAINER Ives van Hoorne

RUN mkdir /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app
