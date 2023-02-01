FROM node:lts-alpine AS build

RUN mkdir -p /app
WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force;
ENTRYPOINT ["npm", "run", "dev"]