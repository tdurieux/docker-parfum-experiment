# install production dependencies for apps/frontend
FROM node:16.14-alpine AS deps

WORKDIR /app

ENV NODE_ENV="production"

RUN mkdir -p apps/frontend
COPY package.json package-lock.json ./
COPY apps/frontend/package.json ./apps/frontend/
RUN npm ci


# build a production version of apps/frontend (including dependencies)
FROM node:16.14-alpine AS builder

WORKDIR /app

RUN apk add --no-cache git

RUN mkdir -p apps/frontend packages/ui
COPY package.json package-lock.json ./
COPY apps/frontend/package.json ./apps/frontend/
COPY packages/ui/package.json ./packages/ui/
RUN npm ci

ENV NODE_ENV="production"

COPY turbo.json ./
COPY apps/frontend/ ./apps/frontend/
COPY packages/ui/ ./packages/ui/

RUN npx turbo run build \
    --scope="@klicker-uzh/frontend" \
    --include-dependencies \
    --no-deps


# build a runtime image of apps/frontend