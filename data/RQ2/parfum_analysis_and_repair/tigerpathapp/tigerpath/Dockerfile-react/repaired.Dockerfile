# Use Node
FROM node:8.11 AS reactapp

ARG APP_DIR=/opt/tigerpath
RUN mkdir "$APP_DIR"
RUN mkdir "$APP_DIR/frontend"

WORKDIR "$APP_DIR/frontend"

ADD frontend/package.json .
ADD frontend/package-lock.json .

RUN npm install && npm cache clean --force;

EXPOSE 3000

ADD frontend .
