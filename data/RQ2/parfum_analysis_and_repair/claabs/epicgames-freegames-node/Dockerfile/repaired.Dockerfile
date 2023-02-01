########
# BASE
########
FROM node:16-alpine3.15 as base

ENV DISTRO=alpine
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1

WORKDIR /usr/app

########
# DEPS
########
FROM base as deps

# Chromium dependencies https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#running-on-alpine
# To find latest chromium version for puppeteer, go to https://github.com/puppeteer/puppeteer/blob/v13.4.0/src/revisions.ts,
# select the correct tag for the puppeteer version, and note the chromium revision number. Then go
# to https://omahaproxy.appspot.com/ and in "Find Releases" search for "r<version number>". Then
# ensure that version is published at https://pkgs.alpinelinux.org/package/v3.15/community/x86_64/chromium
RUN apk add --no-cache \
    'chromium=~99' \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    # App dependencies
    jq \
    tzdata \
    tini

########
# BUILD
########
FROM base as build

# Copy all source files
COPY package*.json tsconfig.json ./

# Add dev deps
RUN npm ci

# Copy source code
COPY src src

RUN npm run build

########
# DEPLOY
########
FROM deps as deploy

# Copy package.json for version number
COPY package*.json ./

RUN npm ci --only=production

# Steal compiled code from build image
COPY --from=build /usr/app/dist ./dist

COPY entrypoint.sh /usr/local/bin/docker-entrypoint.sh
# backwards compat (from https://success.docker.com/article/use-a-script-to-initialize-stateful-container-data)