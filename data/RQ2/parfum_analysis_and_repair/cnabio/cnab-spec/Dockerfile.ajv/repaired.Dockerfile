FROM node:8-alpine

RUN apk add --no-cache curl jq

RUN npm install -g ajv-cli@3.3.0 && npm cache clean --force;