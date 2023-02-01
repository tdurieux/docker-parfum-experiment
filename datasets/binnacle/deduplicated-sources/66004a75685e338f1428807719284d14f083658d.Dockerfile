FROM node:latest
MAINTAINER Jeehoon Yoo <jeehoon.yoo@ridi.com>

RUN npm install -g json-server

ADD mock-db.json /var/lightweight-rest-tester/mock-db.json

WORKDIR /var/lightweight-rest-tester

CMD ["json-server","--watch","mock-db.json"]

HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:3000 || exit 1
