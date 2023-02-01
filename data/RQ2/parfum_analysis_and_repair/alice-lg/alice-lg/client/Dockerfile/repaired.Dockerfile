#
# Client build Dockerfile
# Use node:10 as base image
#

FROM node:11

RUN npm install -g gulp@3.9.1 && npm cache clean --force;
RUN npm install -g gulp-cli && npm cache clean --force;


WORKDIR /client
VOLUME ["/client"]

