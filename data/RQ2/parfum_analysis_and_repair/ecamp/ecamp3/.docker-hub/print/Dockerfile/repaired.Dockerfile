# build stage
FROM node:16.16.0@sha256:2e1b4542d4a06e0e0442dc38af1f4828760aecc9db2b95e7df87f573640d98cd AS build-stage

COPY common /common

WORKDIR /app

COPY print/package*.json ./
RUN npm ci

COPY print .
RUN npm run build

# production stage