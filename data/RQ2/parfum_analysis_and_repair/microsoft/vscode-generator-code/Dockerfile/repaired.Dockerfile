FROM node:lts-alpine3.12
LABEL Maintainer="contact@snpranav.com"

# Installing GIT
RUN apk update && apk add --no-cache git

# Installing Yeoman and VS Code Extension Generator globally
RUN npm install -g yo generator-code && npm cache clean --force;
RUN chown -R node:node /usr/local/lib/node_modules

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .

RUN chown -R node:node /usr/src/app
USER node
ENTRYPOINT [ "yo", "code" ]