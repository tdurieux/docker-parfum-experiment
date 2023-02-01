# build stage
FROM node:lts-alpine@sha256:554142f9a6367f1fbd776a1b2048fab3a2cc7aa477d7fe9c00ce0f110aa45716 AS build-stage

COPY common /common

WORKDIR /app
COPY frontend/package*.json ./
# install and uninstall the native dependencies in one single docker RUN instruction,
# so they do not increase the image layer size
RUN apk --no-cache add --virtual native-deps g++ make python3 && npm ci && apk del native-deps
COPY frontend .
RUN npm run build

# production stage