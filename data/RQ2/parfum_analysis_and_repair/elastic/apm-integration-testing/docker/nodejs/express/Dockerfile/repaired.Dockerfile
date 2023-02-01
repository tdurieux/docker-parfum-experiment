FROM node:16.15.0

RUN mkdir -p /app
COPY package.json .npmrc app.js /app/

WORKDIR /app
RUN npm install && npm cache clean --force;

ARG NODE_AGENT_PACKAGE=
RUN npm install $NODE_AGENT_PACKAGE && npm cache clean --force;
