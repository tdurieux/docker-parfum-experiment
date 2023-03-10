FROM node:lts-alpine

RUN apk add --no-cache libc6-compat

ENV NODE_ENV development

WORKDIR /usr/src/app

COPY ./package.json  /usr/src/app/

RUN yarn install --frozen-lockfile && yarn cache clean;

EXPOSE 3000