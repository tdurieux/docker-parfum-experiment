# sha256 as of 2021-07-22
FROM node:14-alpine@sha256:5c33bc6f021453ae2e393e6e20650a4df0a4737b1882d389f17069dc1933fdc5

# Install npm, making output less verbose
ARG NPM_VER=7.24.1
ENV NPM_CONFIG_LOGLEVEL warn
RUN npm install npm@${NPM_VER} -g && npm cache clean --force;

# Workaround to avoid webpack hanging, see:
# https://github.com/webpack/webpack-dev-server/issues/128
ENV UV_THREADPOOL_SIZE 128

# docker-compose must pass in the host UID here so that the volume
# permissions are correct
ARG USERID
# The node image uses BusyBox adduser, so short options here only. The
# image already has a 'node' user. If it matches our UID, just use it,
# but if it doesn't, create a user with a different name.
RUN getent passwd "${USERID?USERID must be supplied}" || adduser -D -g "" -u "${USERID}" stn_node

# Oddly, node-sass requires both python and make to build bindings
RUN apk add --no-cache paxctl python make g++
RUN paxctl -cm /usr/local/bin/node

USER ${USERID}
