FROM node:10.9.0 as builder
WORKDIR /usr/app
COPY . .
WORKDIR /usr/app/frontend
RUN npm install && npm cache clean --force;
RUN npm run build
WORKDIR /usr/app/backend
RUN npm install && npm cache clean --force;
