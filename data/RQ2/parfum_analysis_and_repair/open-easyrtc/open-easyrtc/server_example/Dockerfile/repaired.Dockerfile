# Pull base image.
FROM node:14-alpine
MAINTAINER Harold Thetiot <hthetiot@gmail.com>

# Upgrade npm
RUN npm i npm@latest -g && npm cache clean --force;
ENV NO_UPDATE_NOTIFIER 1

# Create app directory
ENV APPDIR /usr/src/app
RUN mkdir -p $APPDIR
WORKDIR $APPDIR

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
ADD package*.json $APPDIR/
RUN npm install && npm cache clean --force;

# Install dependencies in production mode (no dev dependencies).
ARG EASYRTC_BRANCH=master
RUN npm install open-easyrtc@latest && npm cache clean --force;
RUN npm install --production && npm cache clean --force;

ADD . $APPDIR

VOLUME ['certs', 'static']

# Replace 'easyrtc = require("..");' by 'easyrtc = require("open-easyrtc");''
# To use easyrtc from node_modules instead of parent directory
RUN sed -i "s|easyrtc = require(\"../\")|easyrtc = require(\"open-easyrtc\")|g" $APPDIR/*.js

# Define service user
RUN chown -R nobody:nogroup $APPDIR && chmod -R a-w $APPDIR && ls -ld
USER nobody

# Ports > 1024 since we're not root.
EXPOSE 8080 8443

ENV SYLAPS_ENV all

ENTRYPOINT ["npm"]
CMD ["start"]
