FROM node:erbium-alpine

WORKDIR /importer

RUN npm install -g wait-on@5.0.1 && npm cache clean --force;

RUN npm install -g axios@0.19.2 && npm cache clean --force;

ENV NODE_PATH ../../usr/local/lib/node_modules
