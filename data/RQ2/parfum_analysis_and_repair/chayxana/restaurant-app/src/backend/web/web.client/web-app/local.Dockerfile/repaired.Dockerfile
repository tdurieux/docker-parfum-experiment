# Stage 1
FROM node:8.11.2-alpine as builder
WORKDIR /usr/src/app
COPY package*.json yarn.lock ./
RUN yarn
COPY . ./
RUN yarn build

# Stage 2