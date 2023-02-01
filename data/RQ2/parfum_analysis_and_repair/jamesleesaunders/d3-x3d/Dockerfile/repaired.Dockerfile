FROM node:latest as base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    vim-tiny \
    telnet \
    less \
    zip && rm -rf /var/lib/apt/lists/*;

FROM base as deps
WORKDIR /home/developer

COPY package.json .
RUN npm i --no-optional && npm cache clean --force;

FROM deps as build
COPY . .
RUN npm test && npm build
