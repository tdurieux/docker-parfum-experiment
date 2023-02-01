# Builder stage
FROM node:17-alpine AS builder
WORKDIR /usr/src/vk2discord

COPY package*.json ./
COPY tsconfig*.json ./

COPY ./src ./src
COPY ./scripts ./scripts

RUN npm ci --quiet && npm run build

# Production stage