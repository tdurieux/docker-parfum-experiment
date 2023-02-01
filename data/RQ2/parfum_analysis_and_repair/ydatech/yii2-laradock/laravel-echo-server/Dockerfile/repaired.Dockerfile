FROM node:alpine

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/

RUN apk add --no-cache --update \
    python \
    python-dev \
    py-pip \
    build-base

RUN npm install && npm cache clean --force;

# Bundle app source
COPY laravel-echo-server.json /usr/src/app/laravel-echo-server.json

EXPOSE 3000
CMD [ "npm", "start" ]
