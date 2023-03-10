# Dockerfile that produce Lightweight runtime images
# Inspired by https://github.com/zeit/next.js/issues/121#issuecomment-541399420

# -- BASE STAGE --------------------------------

FROM node:16-alpine AS base

WORKDIR /src

COPY package*.json ./
RUN npm ci --no-audit

# -- CHECK STAGE --------------------------------

FROM base AS check

ARG CI
ENV CI $CI

COPY . .
RUN npm run lint
RUN npm test

# -- BUILD STAGE --------------------------------

FROM base AS build

# Define build arguments & map them to environment variables
ARG GTM_CONTAINER_ID
ENV GTM_CONTAINER_ID $GTM_CONTAINER_ID
ARG SITE_URL
ENV SITE_URL $SITE_URL

# Build the project and then dispose files not necessary to run the project
# This will make the runtime image as small as possible
COPY . .
RUN npx next telemetry disable > /dev/null
RUN npm run build
RUN npm prune --production --no-audit
RUN rm -rf .next/cache

# -- RUNTIME STAGE --------------------------------