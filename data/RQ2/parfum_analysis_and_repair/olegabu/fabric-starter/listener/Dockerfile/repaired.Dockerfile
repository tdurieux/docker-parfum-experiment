FROM node:8-alpine

MAINTAINER olegabu

# Create app directory
WORKDIR /usr/src/app

## install dependencies
COPY "package.json" .

RUN apk add --no-cache git python make g++

RUN npm install && npm cache clean --force;

# add project files (see .dockerignore for a list of excluded files)
COPY "*.js" "./"

CMD [ "npm", "start" ]
