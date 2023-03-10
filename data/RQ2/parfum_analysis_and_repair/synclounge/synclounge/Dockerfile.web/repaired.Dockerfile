# build environment
FROM --platform=$BUILDPLATFORM node:16.15.0-alpine3.15 as build-stage
RUN mkdir /app && chown -R node:node /app
WORKDIR /app
RUN apk add --no-cache python3 make g++
USER node
COPY --chown=node:node package*.json ./
RUN SKIP_BUILD=true npm ci
COPY --chown=node:node . .

ARG SERVERS
ARG VERSION

RUN npm run build

# production environment