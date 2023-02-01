# base image
FROM node:14-slim

EXPOSE 8000

RUN apt-get update && apt-get install --no-install-recommends python build-essential -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
WORKDIR /app

COPY package*.json /app/

RUN npm install && npm cache clean --force;

COPY . /app/