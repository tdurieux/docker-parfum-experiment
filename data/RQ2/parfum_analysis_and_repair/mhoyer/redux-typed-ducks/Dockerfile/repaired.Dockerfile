FROM node:16-alpine AS build
  WORKDIR /build

  RUN npm install -g npm && npm cache clean --force;
  COPY ./package.json ./yarn.lock ./
  RUN yarn install --ignore-scripts ; yarn cache clean; yarn outdated

  COPY ./tsconfig.json ./tslint.json ./
  COPY ./index.ts ./
  COPY ./example ./example/
  COPY ./lib ./lib/
  COPY ./spec ./spec/

  RUN yarn prepublish && yarn cache clean;
