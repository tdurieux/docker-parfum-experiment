# builder for frontend
FROM node:16.10.0-alpine AS builder

WORKDIR /app

COPY ./ .

RUN rm -rf ./.nuxt && \
  yarn config set registry https://registry.npm.taobao.org && \
  yarn && \
  yarn cache clean && \
  npm cache clean --force && \
  npm run build

# target