# slim image used simply to reduce build download time, if problems arise just use non-slim variant.
FROM node:16.11-bullseye-slim

WORKDIR /app

RUN yarn add http-server

COPY package.json ./
COPY dist-storybook ./dist-storybook
COPY public ./public

EXPOSE 6006 8081
