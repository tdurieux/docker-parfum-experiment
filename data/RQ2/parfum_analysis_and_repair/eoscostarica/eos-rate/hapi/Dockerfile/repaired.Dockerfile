# ---------- Base ----------
FROM node:14.16.0 as base
WORKDIR /app

# ---------- Builder ----------
FROM base AS builder
COPY package.json ./
COPY yarn.lock ./
RUN yarn --ignore-optional
COPY ./src ./src

# ---------- Release ----------