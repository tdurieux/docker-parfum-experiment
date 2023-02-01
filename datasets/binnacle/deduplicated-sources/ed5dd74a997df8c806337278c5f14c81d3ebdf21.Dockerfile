#
# build:
#   docker build --force-rm -t qas/boilerplate-server-node-swagger-api .
# run:
#   docker run --rm --it --env-file=path/to/.env --name boilerplate-server-node-swagger-api -p 80:7071 qas/boilerplate-server-node-swagger-api
#

### BASE
FROM node:8.9.4-alpine AS base
LABEL maintainer "Qasim Soomro <qasim@soomro.com>"
# Set the working directory
WORKDIR /app
# Copy project specification and dependencies lock files
COPY package.json tsconfig.json yarn.lock tsoa.json ./
# Install yarn
RUN apk --no-cache add yarn


### DEPENDENCIES
FROM base AS dependencies
# Install Node.js dependencies (only production)
RUN yarn --production
# Copy production dependencies aside
RUN cp -R node_modules /tmp/node_modules


### TEST
FROM dependencies AS test
# Copy app sources
COPY . .
# Install ALL Node.js dependencies
RUN yarn
# Build Swagger and routes
RUN yarn swagger-gen && routes-gen
# Run linters and tests
RUN yarn lint && yarn test


### BUILD
FROM base as build
# Copy app sources
COPY . .
# Install ALL Node.js dependencies
RUN yarn
# Run build
RUN yarn build
# Copy production distribution source aside
RUN cp -R build /tmp/build


### RELEASE
FROM base AS release
# Copy production dependencies
COPY --from=dependencies /tmp/node_modules ./node_modules
# Copy app sources
COPY --from=build /tmp/build ./build
# Expose application port
EXPOSE 7070
# In production environment
ENV NODE_ENV production
# Run
# TODO: Replace to PM2 after fixing PM2 memory leak bug
# CMD yarn run pm2-runtime --env production --raw process.json | yarn run bunyan
CMD yarn start
