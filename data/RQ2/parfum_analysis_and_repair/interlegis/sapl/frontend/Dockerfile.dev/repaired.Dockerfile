FROM node:lts-alpine
RUN apk add --no-cache bash
WORKDIR /sapl-frontend-dev
COPY package*.json ./
RUN npm install && npm cache clean --force;
EXPOSE 8080
