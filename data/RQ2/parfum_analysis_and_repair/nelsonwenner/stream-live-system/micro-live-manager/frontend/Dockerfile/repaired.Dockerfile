FROM node:10.16-slim

RUN mkdir -p /frontend/src

WORKDIR /frontend/src

COPY . .

RUN npm install && npm cache clean --force;

RUN npm run build