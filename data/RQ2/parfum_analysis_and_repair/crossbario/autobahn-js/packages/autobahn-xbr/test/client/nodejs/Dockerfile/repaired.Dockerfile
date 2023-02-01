FROM node:11-stretch

WORKDIR /opt/xbr-example
ADD package.json .
RUN npm install && npm cache clean --force;
ADD . .

ENTRYPOINT /bin/bash
