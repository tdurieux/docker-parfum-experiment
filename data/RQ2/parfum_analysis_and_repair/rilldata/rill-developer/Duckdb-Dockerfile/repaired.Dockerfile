FROM node:16

WORKDIR /app

RUN npm install duckdb@0.3.2 && npm cache clean --force;
