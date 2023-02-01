#
# KOA REST API BOILERPLATE
#
# build:
#   docker build --force-rm -t qasimsoomro/koa-rest-api-boilerplate .
# run:
#   docker run --rm --it --env-file=path/to/.env --name koa-rest-api-boilerplate -p 80:7071 qasimsoomro/koa-rest-api-boilerplate
#
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
# Install Node.js dependencies
RUN yarn
# Install concurrently
RUN yarn add global concurrently
# Build Swagger and routes
RUN yarn swagger-gen && yarn routes-gen


### TEST
FROM dependencies AS test
# Copy app sources
COPY . .
# Run linters and tests
RUN yarn lint && yarn test


### DEVELOPMENT
FROM dependencies as development
# Copy app sources
COPY . .
# Expose application port
EXPOSE 7070
# In development environment
ENV NODE_ENV development
# Run
CMD yarn dev
