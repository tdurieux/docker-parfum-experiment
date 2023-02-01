FROM node:14-alpine AS development

WORKDIR /app

COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

RUN npm install && npm cache clean --force;

EXPOSE 3000