FROM node:10
MAINTAINER Isan-Rivkin
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm -g config set user root
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 8080
RUN apt-get update