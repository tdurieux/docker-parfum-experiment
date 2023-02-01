###########
# Builder #
###########
FROM node:12.14-alpine AS builder

WORKDIR /usr/src

COPY package*.json ./
RUN npm ci

COPY . .

RUN npm run build

#########
# Image #
#########