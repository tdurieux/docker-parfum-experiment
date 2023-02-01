# base image
FROM node:14.16

ENV NODE_ROOT /usr/src/app
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . .

RUN npm install @angular/cli -g --silent && npm cache clean --force;
RUN npm install && npm cache clean --force;

EXPOSE 4200 49153
