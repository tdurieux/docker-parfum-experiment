FROM node:17 AS builder
COPY . /app
WORKDIR /app
RUN yarn && \
    yarn build && yarn cache clean;
CMD yarn start:dev
