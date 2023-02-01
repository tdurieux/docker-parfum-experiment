## Build
FROM  mhart/alpine-node:latest as build-env

WORKDIR /app

COPY . ./
RUN npm ci --only=production
RUN mkdir node_modules/.cache && chmod -R 777 node_modules/.cache
RUN npm run build

## Serve