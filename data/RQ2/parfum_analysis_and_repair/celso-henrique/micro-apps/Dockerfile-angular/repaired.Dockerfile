# build environment
FROM node:10.15.3-alpine as builder

COPY header /header

WORKDIR /app

COPY angular-app/package.json .
COPY angular-app/package-lock.json .
RUN npm ci --silent
COPY angular-app .
RUN npm run build

# production environment