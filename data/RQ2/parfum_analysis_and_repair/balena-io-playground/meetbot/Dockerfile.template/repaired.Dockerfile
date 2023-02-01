# BUILD STAGE
FROM balenalib/%%BALENA_MACHINE_NAME%%-alpine-node:14-build as builder
WORKDIR /usr/src

COPY package*.json ./
RUN npm ci

#dev-cmd-live=npm run watch

COPY tsconfig.json .
COPY vite.config.ts .
COPY src src

# Build project for run stage
RUN npm run build

# RUN STAGE