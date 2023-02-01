FROM node:argon
MAINTAINER Bruno Vieira <mail@bmpvieira.com>

RUN npm install -g bionode-fasta && npm cache clean --force;
