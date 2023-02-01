# filesys dockerfile

# FROM node:15  # huge 350mb compressed images
# FROM node:15-alpine  # smallest, but harder to work with
# FROM node:15.14-slim

# ubuntu includes python and has images for ARM also
# see https://hub.docker.com/_/ubuntu
FROM ubuntu:21.04

# prevent apt install from getting stuck at timezone info
# see https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install --no-install-recommends --fix-missing -y nodejs npm && rm -rf /var/lib/apt/lists/*;

# install javascript dependencies
WORKDIR /data
ENV NODE_ENV production
COPY ./package*.json ./
RUN npm ci --production

# install app
WORKDIR /data/app
ENV PATH /data/node_modules/.bin:$PATH
COPY ./index.js .

# base command - can pass params with CMD
ENTRYPOINT ["node", "/data/app/src/index.js"]
