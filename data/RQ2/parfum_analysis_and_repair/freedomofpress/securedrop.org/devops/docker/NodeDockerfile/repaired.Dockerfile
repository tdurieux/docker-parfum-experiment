# sha256 as of 2021-07-22
FROM node:14-alpine@sha256:5c33bc6f021453ae2e393e6e20650a4df0a4737b1882d389f17069dc1933fdc5

# Install npm, making output less verbose
ARG NPM_VER=6.14.11
ENV NPM_CONFIG_LOGLEVEL warn
RUN npm install npm@${NPM_VER} -g && npm cache clean --force;

RUN apk add --no-cache paxctl python make g++
RUN paxctl -cm /usr/local/bin/node

ARG USERID
RUN getent passwd "${USERID?USERID must be supplied}" || adduser -D -g "" -u "${USERID}" sdo_node
USER ${USERID}

CMD npm install && touch .node_complete && npm run start
