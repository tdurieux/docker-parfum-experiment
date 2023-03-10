FROM node:6.10

WORKDIR /app
COPY . /app
RUN npm install && npm cache clean --force;

ENTRYPOINT '/bin/bash'
