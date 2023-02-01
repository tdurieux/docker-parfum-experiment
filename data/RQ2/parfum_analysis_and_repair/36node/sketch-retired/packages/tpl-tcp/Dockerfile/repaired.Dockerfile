FROM node:10-alpine

ENV DEBUG=off \
  NODE_ENV=production \
  APP_PORT=9527

RUN mkdir app
WORKDIR /app
COPY . /app/

RUN NODE_ENV=production yarn install && yarn cache clean;

# Start
CMD bin/server.js