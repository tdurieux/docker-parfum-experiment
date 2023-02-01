# build stage (use full node image to provide tooling needed for CI)
FROM node:10.9.0 as build-stage

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci
COPY . /usr/src/app/

# final stage (using slim)