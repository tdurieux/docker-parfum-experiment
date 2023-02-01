# Builder stage
FROM node:12-alpine as builder

WORKDIR /root/

COPY package*.json ./
COPY tsconfig*.json ./
COPY ./src ./src

RUN npm ci --quiet && npm run build
RUN find build/

# Prod stage