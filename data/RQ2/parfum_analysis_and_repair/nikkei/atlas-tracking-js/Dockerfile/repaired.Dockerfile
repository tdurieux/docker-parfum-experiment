FROM node:15.11.0-alpine

RUN mkdir -p /var/atj

ADD ./ /var/atj
WORKDIR /var/atj

RUN apk add --no-cache python make g++ openjdk8-jre chromium grep

ENV PATH $PATH:/var/atj/node_modules

RUN npm install && npm cache clean --force;

CMD ["/bin/sh"]

