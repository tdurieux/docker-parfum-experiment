ARG APP_PATH=/opt/outline
FROM node:16.14.2-alpine3.15 AS deps

ARG APP_PATH
WORKDIR $APP_PATH
COPY ./package.json ./yarn.lock ./

RUN yarn install --no-optional --frozen-lockfile --network-timeout 1000000 && \
  yarn cache clean && yarn cache clean;

COPY . .
ARG CDN_URL
RUN yarn build && yarn cache clean;

RUN rm -rf node_modules

RUN yarn install --production=true --frozen-lockfile --network-timeout 1000000 && \
  yarn cache clean && yarn cache clean;
