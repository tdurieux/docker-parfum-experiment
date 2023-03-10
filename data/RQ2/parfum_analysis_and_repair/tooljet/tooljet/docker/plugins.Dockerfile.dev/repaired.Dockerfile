# pull official base image
FROM node:14.17.3-buster

RUN npm i -g npm@7.20.0 && npm cache clean --force;

# set working directory
WORKDIR /app

COPY ./package.json ./package.json

# Fix for heap limit allocation issue
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Build plugins
COPY ./plugins/package.json ./plugins/package-lock.json ./plugins/
RUN npm --prefix plugins install && npm cache clean --force;
COPY ./plugins/ ./plugins/