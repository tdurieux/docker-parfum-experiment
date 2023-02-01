# build environment
FROM node:10.15.3-alpine as builder

COPY header /header

WORKDIR /app

COPY vue-app/package.json .
COPY vue-app/package-lock.json .
RUN npm ci --silent
COPY vue-app .
RUN npm run build

# production environment