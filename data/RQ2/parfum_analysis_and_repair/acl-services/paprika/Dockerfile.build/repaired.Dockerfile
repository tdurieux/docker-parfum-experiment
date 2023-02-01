FROM node:12-alpine

ENV DIR /src

RUN apk update && apk add --no-cache \
    make \
    yarn \
    bash

COPY . $DIR
WORKDIR $DIR

RUN yarn
RUN npx lerna bootstrap
RUN yarn storybook:build