FROM node:8.9
MAINTAINER hans@webmapper.net
WORKDIR /app

RUN apt-get update -y

RUN npm install -g lerna@3.22.1 rollup@0.57.1 && npm cache clean --force;
COPY package.json package-lock.json /app/
COPY packages /app/packages
RUN npm install && npm cache clean --force;
RUN lerna init
RUN lerna bootstrap
RUN lerna exec npm install
COPY scripts /app/scripts
