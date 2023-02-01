# stage builder
FROM node:16-alpine AS builder

ENV NODE_ENV=production
WORKDIR /usr/src/app

# package, package-lock, tsconfig
COPY *.json ./
RUN npm ci --include=dev

COPY src/. src/.
RUN npm run build

# stage run-time