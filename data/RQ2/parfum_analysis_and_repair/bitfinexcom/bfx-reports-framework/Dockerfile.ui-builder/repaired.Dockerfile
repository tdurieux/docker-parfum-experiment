FROM node:14.16.0-alpine

WORKDIR /home/node/bfx-report-ui

RUN apk add --no-cache --virtual \
  .gyp \
  python3 \
  make \
  g++ \
  git \
  openssh \
  bash

COPY ./scripts/maintenance/index.html var/www/html/maintenance.html
COPY ./bfx-report-ui/package*.json ./
RUN npm i --no-audit && npm cache clean --force;

COPY ./bfx-report-ui .
COPY ./scripts/build-ui.sh /usr/local/bin/

ENTRYPOINT ["build-ui.sh"]
