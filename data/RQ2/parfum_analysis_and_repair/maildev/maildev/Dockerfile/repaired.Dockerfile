# Base
FROM node:16-alpine as base
ENV NODE_ENV production

# Build
FROM base as build
WORKDIR /root
COPY package*.json ./
RUN npm install \
  && npm prune \
  && npm cache clean --force

# Prod