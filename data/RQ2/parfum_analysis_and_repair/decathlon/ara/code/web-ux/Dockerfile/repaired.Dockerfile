# STAGE 1 : build
FROM node:16 as builder

WORKDIR /usr/src/app

COPY . ./

RUN npm ci

RUN npm run build

# STAGE 2 : serve