FROM node:16-alpine

WORKDIR /src

RUN apk update && \
    apk add --no-cache openjdk11
RUN npm i -g firebase-tools@10.9.2 && npm cache clean --force;
RUN firebase --version
EXPOSE 4001 4002 4400 4500 5000 5001 8001 8080 8085 9000