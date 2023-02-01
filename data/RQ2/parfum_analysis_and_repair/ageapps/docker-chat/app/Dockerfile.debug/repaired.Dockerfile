FROM node:6.10-slim

MAINTAINER Adrián García Espinosa "age.apps.dev@gmail.com"

# Create app directory
WORKDIR /app

# Bundle app source
COPY . /app

# Install npm and bower dependencies
RUN npm install && npm cache clean --force;

RUN npm install nodemon -g && npm cache clean --force;

CMD nodemon -L /app/bin/www
