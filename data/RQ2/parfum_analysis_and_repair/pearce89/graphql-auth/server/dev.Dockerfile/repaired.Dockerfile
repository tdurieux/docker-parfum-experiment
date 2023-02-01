FROM node:11-slim

ENV APP_NAME /graphql-auth-server
RUN mkdir /$APP_NAME
WORKDIR /$APP_NAME

COPY package.json /$APP_NAME
RUN npm install && npm cache clean --force;

COPY . /$APP_NAME
