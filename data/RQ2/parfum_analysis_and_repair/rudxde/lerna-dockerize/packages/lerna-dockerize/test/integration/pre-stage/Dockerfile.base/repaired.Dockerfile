ARG NODE_VERSION=16
FROM node:${NODE_VERSION} as base
COPY ./package.json ./
RUN npm install && npm cache clean --force;
