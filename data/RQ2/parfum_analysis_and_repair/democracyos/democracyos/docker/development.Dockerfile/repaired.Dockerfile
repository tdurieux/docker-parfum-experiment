FROM node:6

MAINTAINER Guido Vilariño <guido@democracyos.org>

RUN npm config set python python2.7

COPY ["package.json", "/usr/src/"]

WORKDIR /usr/src

ENV NODE_PATH=.

RUN npm install --quiet --production && npm cache clean --force;

RUN npm install --quiet --only=development && npm cache clean --force;

COPY [".", "/usr/src/"]

EXPOSE 3000

CMD ["./node_modules/.bin/gulp", "bws"]
