From node:13-slim

WORKDIR /web


ADD . /web

RUN npm install && npm cache clean --force;
RUN npm run build
CMD node server.js