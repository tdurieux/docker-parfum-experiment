FROM node:8.16.0-alpine

COPY . /viewer/

RUN set -x && \
  cd /viewer/ && \
  npm install && npm cache clean --force;

ENTRYPOINT ["node", "/viewer/app.js"]
