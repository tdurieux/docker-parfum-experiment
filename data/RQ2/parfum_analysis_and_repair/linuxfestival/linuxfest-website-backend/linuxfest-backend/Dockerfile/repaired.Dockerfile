FROM node:16.10.0-alpine

WORKDIR /app
COPY package.json .

ARG NODE_ENV
RUN if [ "$NODE_ENV" = "production" ]; \
        then \
        npm install --only=production; npm cache clean --force; \
        else npm install; npm cache clean --force; \
        fi

COPY . ./


ENV PORT 5000
EXPOSE $PORT
