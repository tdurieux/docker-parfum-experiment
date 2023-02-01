# this dockerfile is for dev instance
FROM node:15.11.0-alpine3.10
EXPOSE 2020

RUN mkdir -p /app
WORKDIR /app

RUN apk update

RUN apk add --no-cache dumb-init

# first copy only dependency files for caching yarn install
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

RUN cd /app
# install nodejs packages
RUN npm install && npm cache clean --force;

ENTRYPOINT ["dumb-init"]