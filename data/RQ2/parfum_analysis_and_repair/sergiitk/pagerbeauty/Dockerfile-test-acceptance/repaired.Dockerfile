# https://hub.docker.com/_/node/
FROM node:14.16.1-alpine
ARG VCS_REF=not_ci
LABEL org.label-schema.description="PagerDuty on-call dashboard widget" \
      org.label-schema.name="PagerBeauty" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url="https://work.sergii.org/pagerbeauty" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/sergiitk/pagerbeauty" \
      org.label-schema.vendor="Sergii Tkachenko <hi@sergii.org>"

# Environment
ENV APP_DIR=/usr/src/app

# Create app directory
WORKDIR $APP_DIR

# Install
COPY package.json yarn.lock $APP_DIR/
RUN yarn install --prod --frozen-lockfile \
  && yarn cache clean

# Pagerbeauty default port
EXPOSE 8080

# ---------- Dev image from here
# NPM config and dev environment
RUN  npm config set scripts-prepend-node-path true \
  && mkdir -v $APP_DIR/tmp

# Install the rest
RUN yarn install --frozen-lockfile && yarn cache clean;

# ---------- Acceptance test image from here
# Installs latest Chromium 81.0.4044.113-r0 available in Apline 3.11:
# Alpine: https://github.com/nodejs/docker-node/blob/8b8ee/12/alpine3.11/Dockerfile
# Chromium: https://pkgs.alpinelinux.org/package/v3.11/community/x86_64/chromium
RUN apk update && apk upgrade && \
    apk add --no-cache \
      chromium

# TODO: create a user and omit no-sandbox

# Set default chrome path
ENV CHROME_PATH=/usr/bin/chromium-browser

# Bundle app source
COPY . .

ENTRYPOINT ["yarn", "run", "test:acceptance"]
