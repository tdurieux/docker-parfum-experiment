FROM node:10.12.0-jessie
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
# Entrypoint can vary so it must be provided at startup
