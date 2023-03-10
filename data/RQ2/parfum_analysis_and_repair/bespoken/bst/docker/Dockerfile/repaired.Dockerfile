FROM node:12

MAINTAINER John Kelvie

EXPOSE 5000 443

WORKDIR /opt

RUN mkdir bst-server

WORKDIR /opt/bst-server

COPY bin/ ./bin/

COPY lib/ ./lib/

COPY *.json ./

RUN npm -version

RUN npm install && npm cache clean --force;

CMD node bin/bst-server.js start 443 5000 80