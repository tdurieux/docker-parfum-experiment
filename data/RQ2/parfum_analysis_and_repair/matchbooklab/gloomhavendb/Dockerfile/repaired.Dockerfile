########
# BASE #
########

FROM node:dubnium-alpine AS base

RUN mkdir /app/ && chown node:node /app/
WORKDIR /app/

USER node

# try to take advtange of caching for large files
COPY ./src/client/assets/ ./src/client/assets/

COPY ./package.json ./package-lock.json ./
RUN npm ci

COPY ./ ./


#########
# BUILD #
#########

FROM node:dubnium-alpine AS build

RUN mkdir /app/ && chown node:node /app/
WORKDIR /app/

COPY --from=base /app/ ./

# this step takes super long and has to be run for every little change, so it's part of its own step
RUN npm run build:prod
RUN npm prune --production

# so the COPY below doesn't fail if we don't have a .env
RUN touch ./.env

#########
# FINAL #
#########