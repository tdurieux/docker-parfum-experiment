FROM node:alpine AS build-env-node
ENV DEBUG=jsftp
WORKDIR /jsftp
COPY package.json .
RUN npm install && npm cache clean --force;
COPY ./lib/jsftp.js ./index.js
COPY ./test/ ./test/
