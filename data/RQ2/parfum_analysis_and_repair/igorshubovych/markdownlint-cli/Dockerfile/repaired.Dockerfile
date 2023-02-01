FROM node:lts-alpine

WORKDIR /app

COPY . .

RUN npm install --production && npm cache clean --force;

RUN npm install --global && npm cache clean --force;

WORKDIR /workdir

ENTRYPOINT ["/usr/local/bin/markdownlint"]
