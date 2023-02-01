# syntax=docker/dockerfile:1

# DEVELOPMENT BUILD
from node:16.3.0 as build
ENV NODE_ENV=development
WORKDIR /app

COPY ["package.json", "yarn.lock", "tsconfig.json", "webpack.*.js" , "./"]

RUN yarn --frozen-lockfile --non-interactive

COPY ./assets ./assets
COPY ./src ./src

RUN yarn build

# PRODUCTION BUILD