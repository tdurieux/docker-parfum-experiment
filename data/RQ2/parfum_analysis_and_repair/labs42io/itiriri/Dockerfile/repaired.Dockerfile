FROM node:10.15.0-jessie

WORKDIR /usr/src/app/
COPY . /usr/src/app/

RUN npm install && npm cache clean --force;
RUN npm install -g gulp && npm cache clean --force;
