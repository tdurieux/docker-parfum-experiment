# This docker image is used to deploy @betaflight/api-server
# in mocked mode to heroku. Used to allow the demo app to
# use the API
FROM node:16 as build

WORKDIR /build
COPY packages packages
COPY tools/demo-api-server tools/demo-api-server
COPY types types
COPY scripts scripts
COPY .yarn .yarn
COPY tsconfig.build.json \
        tsconfig.base.json \
        tsconfig.build.json \
        yarn.lock package.json \
        codegen.yml \
        .gitignore \
        .yarnrc.yml \
        ./

# Build the minimum required to make a functional mock server
RUN rm packages/configurator/package.json && \
        yarn install --mode=skip-build && \
        yarn codegen && yarn build:lib && rm -r packages/configurator && yarn cache clean;

RUN yarn cache clean && \
        yarn workspaces focus @betaflight-tools/demo-api-server --production && yarn cache clean;

# Deployed layer
FROM node:16-alpine

WORKDIR /mock-server
COPY --from=build /build /mock-server
RUN yarn node scripts/substitute-publish-config.js --write

WORKDIR /mock-server/tools/demo-api-server
CMD yarn start
