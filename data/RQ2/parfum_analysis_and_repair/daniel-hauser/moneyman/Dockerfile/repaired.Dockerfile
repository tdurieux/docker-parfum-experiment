# ---- Base Node ----
FROM node:alpine AS base

RUN apk add --no-cache \
      chromium \
      nodejs yarn \
      nss ca-certificates \
      freetype ttf-freefont harfbuzz

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -g pptruser pptruser \
    && mkdir -p /home/pptruser/Downloads /app \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /app
 
USER pptruser

# ---- Builder ----
FROM base AS builder
WORKDIR /app

COPY tsconfig.json .
COPY package.json .
COPY package-lock.json .
COPY ./patches ./patches
COPY ./src ./src

RUN npm ci
RUN npm run build
# RUN npm prune --production

# ---- Release ----