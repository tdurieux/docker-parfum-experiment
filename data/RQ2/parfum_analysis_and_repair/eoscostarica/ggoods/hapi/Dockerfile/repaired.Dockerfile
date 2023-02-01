# ---------- Base ----------
FROM node:14.2.0 as base
WORKDIR /app

# ---------- Builder ----------
FROM base AS builder
COPY package.json yarn.lock ./
RUN yarn --ignore-optional
COPY ./src ./src

# ---------- Release ----------