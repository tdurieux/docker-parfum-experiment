FROM node:alpine

RUN apk add --no-cache git python zeromq-dev gcc make g++ zlib-dev libzmq curl
ENV npm_config_zmq_external="true"

WORKDIR /exporter

COPY . .

RUN npm i level --build-from-source --production --silent && npm cache clean --force;

RUN npm install && npm cache clean --force;

RUN apk del python gcc make g++ git curl

COPY config-template.js config.js

EXPOSE 9311

CMD node app.js
