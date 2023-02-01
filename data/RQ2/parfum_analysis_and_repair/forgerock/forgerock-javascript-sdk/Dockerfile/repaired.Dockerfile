FROM node:alpine as builder

WORKDIR /app/builder
RUN npm i -g nx && npm cache clean --force;

COPY . /app/builder
RUN npm install && npm cache clean --force;

RUN nx run-many --target=build --projects=todo-api,mock-api,autoscript-apps --parallel --skipNxCache
