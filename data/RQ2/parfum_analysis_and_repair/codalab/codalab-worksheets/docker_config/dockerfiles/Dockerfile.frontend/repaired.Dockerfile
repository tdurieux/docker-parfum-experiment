FROM node:14-slim

ENV NPM_CONFIG_LOGLEVEL warn

ARG dev=false

RUN npm install -g serve && npm cache clean --force;

WORKDIR /opt/frontend

# Install dependencies
COPY frontend/package.json ./
COPY frontend/package-lock.json ./
COPY setup-frontend.js setup-frontend.js
RUN npm ci

# Overridden in dev mode
COPY frontend .

# Build static files (skipped in dev mode)
RUN if [ "$dev" = "false" ] ; then npm run build --production; fi

EXPOSE 2700
