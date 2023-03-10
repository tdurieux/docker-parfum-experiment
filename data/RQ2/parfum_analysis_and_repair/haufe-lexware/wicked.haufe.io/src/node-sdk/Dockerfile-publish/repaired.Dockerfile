FROM node:10-alpine

RUN apk update && apk add --no-cache jq
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# This is okay, as it's only the builder image. This will not work on Jenkins otherwise.
RUN npm config set unsafe-perm true
RUN npm install -g npm-cli-login typescript@$(jq .devDependencies.typescript | tr -d '"') && npm cache clean --force;
COPY package.json /usr/src/app
COPY . /usr/src/app

ARG NPM_USER
ARG NPM_PASS
ARG NPM_EMAIL

RUN echo User: $NPM_USER, Email: $NPM_EMAIL
RUN npm-cli-login -u $NPM_USER -p $NPM_PASS -e $NPM_EMAIL && npm install && tsc && npm publish && npm logout && npm cache clean --force;
