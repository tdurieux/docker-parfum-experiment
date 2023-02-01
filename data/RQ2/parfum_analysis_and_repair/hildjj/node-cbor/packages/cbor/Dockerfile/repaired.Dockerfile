FROM node:latest
MAINTAINER Joe Hildebrand <joe-github@cursive.net>

VOLUME /root/.npm
RUN npm install -g nodeunit grunt grunt-cli istanbul && npm cache clean --force;

ADD . /opt/cbor
WORKDIR /opt/cbor

RUN npm install && npm cache clean --force;

CMD ["nodeunit", "test"]
