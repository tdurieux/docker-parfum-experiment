FROM node:8

WORKDIR /src
ADD package.json .
RUN npm install && npm cache clean --force;

ADD . .

