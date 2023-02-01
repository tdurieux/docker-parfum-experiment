# This file is built with Docker context in the main directory (not ./docs)
# so that ./backend is accessible.

FROM node:14-alpine3.14

WORKDIR /app/docs

RUN apk add --update --no-cache build-base python3 vips-dev autoconf automake libtool make tiff jpeg zlib zlib-dev pkgconf nasm file gcc musl-dev

COPY ./docs/package* ./

RUN npm ci

# Generate swagger definitions
COPY ./backend ../backend
COPY ./docs .
RUN npm run codegen

# Configure port used by Gatsby