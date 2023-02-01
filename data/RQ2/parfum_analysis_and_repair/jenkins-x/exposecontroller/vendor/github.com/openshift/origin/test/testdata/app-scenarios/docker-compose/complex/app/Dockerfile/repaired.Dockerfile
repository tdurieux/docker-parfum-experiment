FROM node:0.10.38

RUN mkdir /src

RUN npm install nodemon -g && npm cache clean --force;

WORKDIR /src
ADD package.json package.json
RUN npm install && npm cache clean --force;

ADD nodemon.json nodemon.json
