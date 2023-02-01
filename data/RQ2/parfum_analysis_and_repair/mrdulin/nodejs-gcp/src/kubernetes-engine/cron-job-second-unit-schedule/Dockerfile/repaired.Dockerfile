FROM node:8.9-alpine

WORKDIR /app
COPY ./ /app/

RUN apk update \
  && apk add curl --no-cache \
  && npm i -g npm@latest \
  && npm i --production && npm cache clean --force;

CMD [ "npm", "start" ]