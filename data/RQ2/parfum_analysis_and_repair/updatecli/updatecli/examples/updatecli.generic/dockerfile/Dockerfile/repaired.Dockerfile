### File: Dockerfile.webapp
ARG GO_VERSION=1.15.8
FROM golang:"${GO_VERSION}-alpine" AS build
# Retrieve source code
WORKDIR /app
COPY . /app
# Build application