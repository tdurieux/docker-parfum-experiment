FROM node:lts

LABEL maintainer="void* <voidp@protonmail.com>"

USER root

ENV APP /usr/src/app

RUN npm install pm2 -g && npm cache clean --force;

COPY package.json /tmp/package.json

RUN cd /tmp && npm install --loglevel=warn \
  && mkdir -p $APP \
  && mv /tmp/node_modules $APP && npm cache clean --force;

COPY src $APP/src
COPY data $APP/data
COPY package.json $APP

WORKDIR $APP

CMD [ "pm2-runtime", "src/index.js" ]
