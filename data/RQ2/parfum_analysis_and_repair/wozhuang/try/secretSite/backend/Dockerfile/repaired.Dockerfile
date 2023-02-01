FROM node:alpine as build-deps

WORKDIR /usr/src/app/
USER root
COPY package.json ./
RUN npm install --production --registry=https://registry.npm.taobao.org && npm cache clean --force;

COPY ./ ./


ENTRYPOINT ["npm", "run", "docker-start"]
