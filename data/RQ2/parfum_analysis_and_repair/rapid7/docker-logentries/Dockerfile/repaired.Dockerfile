# docker-logentries
#
# VERSION 0.2.0

FROM node:0.12-onbuild
MAINTAINER Rapid 7 - InsightOps <InsightOpsTeam@rapid7.com>

WORKDIR /usr/src/app
COPY package.json package.json
RUN npm install --production && npm cache clean --force;
COPY index.js /usr/src/app/index.js

ENTRYPOINT ["/usr/src/app/index.js"]
CMD []
