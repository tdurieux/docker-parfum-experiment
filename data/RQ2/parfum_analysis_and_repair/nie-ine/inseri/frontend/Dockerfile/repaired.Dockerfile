# stage builder
FROM node:16-slim as builder
WORKDIR /usr/src/app

# package*.json, tsconfig*.json, tslint.json
COPY *.json ./
RUN npm ci
COPY . ./

ARG NG_CONFIG=production
RUN npx ng build --configuration $NG_CONFIG
RUN gzip -kr9 dist/*

# stage run-time