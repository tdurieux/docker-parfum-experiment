# Base builder image
FROM bitnami/node:14 AS build
WORKDIR /app

COPY package.json ./
COPY yarn.lock ./
RUN yarn

COPY . .

RUN NODE_ENV=production yarn run build

# Production ready image