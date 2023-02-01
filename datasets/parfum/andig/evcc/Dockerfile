# STEP 1 build ui
FROM node:16-alpine as node

RUN apk update && apk add --no-cache make alpine-sdk python3

WORKDIR /build

# install node tools
COPY Makefile .
COPY package*.json ./
RUN make install-ui

# build ui
COPY assets assets
COPY vite.config.js vite.config.js
COPY .eslintrc.js .eslintrc.js
COPY postcss.config.js postcss.config.js

RUN make clean ui


# STEP 2 build executable binary
FROM golang:1.18-alpine as builder

# Install git + SSL ca certificates.
# Git is required for fetching the dependencies.
# Ca-certificates is required to call HTTPS endpoints.
RUN apk update && apk add --no-cache git ca-certificates tzdata alpine-sdk && update-ca-certificates

# define RELEASE=1 to hide commit hash
ARG RELEASE={{ env "RELEASE" }}

WORKDIR /build

# install go tools and cache modules
COPY Makefile .
COPY go.mod .
COPY go.sum .
COPY tools.go .
RUN make install
RUN go mod download

# prepare
COPY . .
RUN make assets

# copy ui
COPY --from=node /build/dist /build/dist

# build
RUN RELEASE=${RELEASE} make build


# STEP 3 build a small image including module support
FROM alpine:3.15

WORKDIR /app

ENV TZ=Europe/Berlin

# Import from builder
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /build/evcc /usr/local/bin/evcc

COPY docker/bin/* /app/

# UI and /api
EXPOSE 7070/tcp
# KEBA charger
EXPOSE 7090/udp
# SMA Energy Manager
EXPOSE 9522/udp

HEALTHCHECK --interval=60s --start-period=60s --timeout=30s --retries=3 CMD [ "evcc", "health" ]

ENTRYPOINT [ "/app/entrypoint.sh" ]
CMD [ "evcc" ]
