from node:12-alpine

RUN mkdir -p /app/node_modules && cd /app && npm install emitter-io commander && npm cache clean --force;
COPY keygen.js /app/
