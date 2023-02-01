# build environment
FROM node:17-alpine as react-build
RUN apk update && apk upgrade
WORKDIR /app
COPY . ./
RUN yarn clean
RUN yarn
RUN yarn build

# server environment