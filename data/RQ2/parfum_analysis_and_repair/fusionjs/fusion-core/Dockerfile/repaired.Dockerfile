ARG BASE_IMAGE=uber/web-base-image:2.0.0
FROM $BASE_IMAGE

WORKDIR /fusion-core

COPY . .

RUN yarn && yarn cache clean;

RUN yarn build-test && yarn cache clean;
