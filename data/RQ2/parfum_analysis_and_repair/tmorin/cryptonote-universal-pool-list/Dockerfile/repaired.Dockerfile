FROM node:8-alpine

RUN apk add --no-cache --update supervisor git

COPY ./docker /
COPY ./package* /opt/
COPY ./lib /opt/lib
COPY ./public /opt/public
COPY ./config /opt/config

WORKDIR /opt

RUN npm install --production && npm cache clean --force;

EXPOSE 8888

ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf"]
