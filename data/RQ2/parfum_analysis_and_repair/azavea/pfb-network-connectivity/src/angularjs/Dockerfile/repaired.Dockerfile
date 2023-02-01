FROM node:6.17-stretch

MAINTAINER Azavea

ENV ANGULAR_DIR /opt/pfb/angularjs

RUN apt-get update && apt-get install --no-install-recommends -y rsync \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g bower gulp && npm cache clean --force;

WORKDIR /opt/pfb/angularjs
COPY package.json ${ANGULAR_DIR}/package.json
RUN npm install && npm cache clean --force;

COPY bower.json ${ANGULAR_DIR}/bower.json
COPY .bowerrc ${ANGULAR_DIR}/.bowerrc
RUN bower install --allow-root --config.interactive=false

COPY .eslintrc ${ANGULAR_DIR}/.eslintrc
COPY gulp ${ANGULAR_DIR}/gulp
COPY src ${ANGULAR_DIR}/src

COPY gulpfile.js ${ANGULAR_DIR}/gulpfile.js

RUN gulp build
