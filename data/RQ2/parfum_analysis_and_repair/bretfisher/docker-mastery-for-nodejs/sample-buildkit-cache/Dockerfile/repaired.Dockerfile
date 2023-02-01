FROM node:14-alpine

WORKDIR /app

COPY package*.json ./

RUN --mount=type=cache,target=/root/.npm/_cacache npm install && npm cache clean --force;

