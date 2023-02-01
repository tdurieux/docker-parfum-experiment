FROM node:11.15.0 as build

WORKDIR /src
ADD ["package.json", "yarn.lock", "./"]

RUN yarn install && yarn cache clean;

ADD [".", "."]

ARG ARGO_VERSION=latest
ENV ARGO_VERSION=$ARGO_VERSION
RUN NODE_ENV='production' yarn build && yarn cache clean;

FROM alpine:3.7

COPY  --from=build ./src/dist/app /app
