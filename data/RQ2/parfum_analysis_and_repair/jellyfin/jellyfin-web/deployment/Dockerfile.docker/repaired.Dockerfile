FROM node:lts-alpine

ARG SOURCE_DIR=/src
ARG ARTIFACT_DIR=/jellyfin-web

RUN apk add --no-cache autoconf g++ make libpng-dev gifsicle alpine-sdk automake libtool make gcc musl-dev nasm python3

WORKDIR ${SOURCE_DIR}
COPY . .

RUN npm ci --no-audit --unsafe-perm && mv dist ${ARTIFACT_DIR}
