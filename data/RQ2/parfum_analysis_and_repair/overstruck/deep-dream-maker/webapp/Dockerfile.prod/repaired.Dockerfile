###################################
# Production Docker file
# built React web app & setup Ngix as server
###################################

# build environment
FROM node:15.7.0-alpine as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json ./
COPY package-lock.json ./
RUN npm ci
COPY . ./
RUN npm run build

# production environment