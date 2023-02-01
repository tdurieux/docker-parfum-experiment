FROM node:16.15.0

WORKDIR /usr/src/api

RUN mkdir -p /usr/src/api && rm -rf /usr/src/api

COPY . /usr/src/api

RUN npm install && npm cache clean --force;

EXPOSE 3000
