# install packages
FROM node:14-alpine as builder
RUN mkdir /work
WORKDIR /work
RUN apk add --no-cache alpine-sdk python3
COPY package*.json ./
RUN mkdir -p node_modules
RUN npm ci --only=production

# fresh image without dev packages
FROM node:14-alpine
# build-time metadata as defined at http://label-schema.org