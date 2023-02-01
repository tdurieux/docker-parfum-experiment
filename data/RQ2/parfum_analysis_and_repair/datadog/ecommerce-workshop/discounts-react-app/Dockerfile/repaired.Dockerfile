# build environment
FROM node:13.12.0-alpine as build
WORKDIR /app
COPY ./src/main ./
ENV PATH /app/node_modules/.bin:$PATH
RUN npm ci
RUN npm run-script build

# production environment