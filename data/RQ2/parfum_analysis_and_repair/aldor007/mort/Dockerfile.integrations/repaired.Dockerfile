FROM node:17-slim

WORKDIR /workdir
RUN mkdir -p /workdir

COPY package.json /workdir/package.json
COPY package-lock.json /workdir/package-lock.json
RUN npm install && npm cache clean --force;

COPY scripts/ /workdir/scripts
COPY tests-int /workdir/tests-int
COPY pkg/ /workdir/pkg
