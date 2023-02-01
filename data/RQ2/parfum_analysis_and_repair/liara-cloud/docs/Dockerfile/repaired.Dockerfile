# 1) Build
FROM node:16-alpine AS builder

WORKDIR /app

COPY package*.json /app/

RUN npm ci

COPY . /app/

RUN npm run build

# 2) Run