# build environment
FROM node:10.15.3-alpine as builder

COPY header /header

WORKDIR /app

COPY react-app/package.json .
COPY react-app/package-lock.json .
RUN npm ci --silent
COPY react-app .
RUN npm run build

# production environment