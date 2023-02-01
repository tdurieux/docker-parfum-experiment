FROM node:latest

MAINTAINER Rodrigo Diaz "programandoconro@gmail.com"

RUN apt update -y
RUN npm install -g node-red && npm cache clean --force;
RUN npm install -g node-red-node-mysql && npm cache clean --force;
RUN npm install -g node-red-node-sqlite && npm cache clean --force;
RUN npm install -g node-red-node-email && npm cache clean --force;
RUN npm install -g node-red-contrib-firebase && npm cache clean --force;
RUN npm install -g node-red-admin && npm cache clean --force;

COPY settings.js /root/.node-red/

VOLUME /home/pi/.node-red

WORKDIR /usr/local/bin/
CMD ["/usr/local/bin/node-red","-v"]
