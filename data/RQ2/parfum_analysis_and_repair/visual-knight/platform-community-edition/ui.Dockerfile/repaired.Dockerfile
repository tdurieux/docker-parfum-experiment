### STAGE 1: Build ###
FROM node:latest AS build
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build:visual-knight

### STAGE 2: Run ###