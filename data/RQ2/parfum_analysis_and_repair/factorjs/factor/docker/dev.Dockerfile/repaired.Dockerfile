FROM node:14-alpine AS build

WORKDIR /src

RUN yarn install && yarn cache clean;

ENTRYPOINT ["npx", "factor", "dev"]

