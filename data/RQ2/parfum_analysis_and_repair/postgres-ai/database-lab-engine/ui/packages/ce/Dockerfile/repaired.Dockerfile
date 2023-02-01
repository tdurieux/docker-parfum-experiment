# Biuld phase.
FROM node:16.13.0-alpine as build

WORKDIR /app

COPY ./ui/ .

RUN npm ci -ws

ARG API_URL_PREFIX
ENV REACT_APP_API_URL_PREFIX ${API_URL_PREFIX}

RUN npm run build -w @postgres.ai/ce

# Run phase.