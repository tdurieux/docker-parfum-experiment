# Build stage: Install yarn dependencies
# ===
FROM node:14 AS yarn-dependencies
WORKDIR /srv
COPY . .
RUN --mount=type=cache,target=/usr/local/share/.cache/yarn CYPRESS_INSTALL_BINARY=0 yarn install && yarn cache clean;

# Build stage: Run "yarn build"
# ===
FROM yarn-dependencies AS build-js
RUN yarn run build

# Setup commands to run server
CMD yarn run serve-static-demo
