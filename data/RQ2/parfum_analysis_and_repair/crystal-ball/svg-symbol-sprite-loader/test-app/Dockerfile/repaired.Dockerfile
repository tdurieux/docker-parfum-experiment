FROM node:14.16-alpine as base
LABEL maintainer="hedgecock.d@gmail.com"

WORKDIR /usr/src/app

RUN npm install -g serve && npm cache clean --force;

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY test-app/package.json .
RUN npm install && npm cache clean --force;

# Bundle app source
COPY test-app .

EXPOSE 5000
EXPOSE 3000
