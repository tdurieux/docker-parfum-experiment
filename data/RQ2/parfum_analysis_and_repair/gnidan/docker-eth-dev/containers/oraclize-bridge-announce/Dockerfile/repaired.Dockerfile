FROM node:6.9.1
MAINTAINER gnidan

RUN \
    npm install chokidar && npm cache clean --force;

ENTRYPOINT \
    node /var/announce/server.js
