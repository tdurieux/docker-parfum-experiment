FROM node:11.10-slim

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

COPY ./noter-frontend/package.json ./
COPY ./noter-frontend/package-lock.json ./

RUN npm ci

COPY ./noter-frontend/ .
RUN npm run build
RUN npm install -g serve && npm cache clean --force;
