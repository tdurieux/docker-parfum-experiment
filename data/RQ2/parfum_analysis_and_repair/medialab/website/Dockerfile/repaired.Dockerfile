# Building sharp
# FROM alpine:edge as vips
# COPY site/package.json package.json
# COPY site/package-lock.json package-lock.json

# RUN set -x && \
#   apk add --no-cache nodejs nodejs-npm

# RUN set -x && \
#   apk add vips-dev fftw-dev build-base python --no-cache \
#     --repository https://alpine.global.ssl.fastly.net/alpine/edge/community/

# RUN set -x && \
#   npm set progress=false && \
#   npm config set depth 0 && \
#   npm ci --quiet --no-audit

# Main container
FROM node:10.12.0-alpine

ENV NODE_ENV production
ENV BABEL_CACHE_PATH /website
ENV BABEL_DISABLE_CACHE 1
ENV DISABLE_SHARP_CACHE 1

RUN apk add --no-cache su-exec util-linux git rsync

COPY --chown=node:node . /website
# COPY --chown=node:node --from=vips node_modules/sharp /website/site/node_modules/sharp