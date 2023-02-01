FROM node:15.2.0-alpine

WORKDIR /cytrus-re

ENV HOSTNAME="Docker-Production"

COPY ./ /cytrus-re

RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python && apk add --no-cache make build-base gcc abuild binutils && npm install && npm cache clean --force;

CMD ["node", "cybase.js"]