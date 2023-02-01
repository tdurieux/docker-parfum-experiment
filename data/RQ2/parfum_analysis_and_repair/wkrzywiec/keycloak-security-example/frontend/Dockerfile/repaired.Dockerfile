### STAGE 1: Build ###
FROM node:16.13-alpine AS build
WORKDIR /usr/src/app
COPY package-lock.json ./
COPY package.json ./
RUN npm ci
COPY . .
RUN npm run build

### STAGE 2: Run ###