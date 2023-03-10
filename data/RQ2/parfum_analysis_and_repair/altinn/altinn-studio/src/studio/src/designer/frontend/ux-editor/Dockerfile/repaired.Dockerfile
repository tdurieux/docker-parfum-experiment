# base image
FROM node:16.15.1-alpine3.16

# set working directory
WORKDIR /usr/src/app

# install and cache app dependencies
COPY package.json .
COPY yarn.lock .
COPY .yarn/ ./.yarn/
COPY .yarnrc.yml .


RUN corepack enable
RUN yarn --immutable

# start app