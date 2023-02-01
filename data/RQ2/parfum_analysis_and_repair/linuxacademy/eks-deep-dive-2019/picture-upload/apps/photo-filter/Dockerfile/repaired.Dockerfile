# This is a multi-stage build.
# It will generate an image ~7.8MB in size with 1 layer.

# build stage
FROM golang:1.11 AS builder
WORKDIR /app/
COPY . .
RUN CGO_ENABLED=0 go build -o app .

# final stage
FROM scratch
COPY --from=builder /app .

# Metadata params
ARG VERSION
ARG BUILD_DATE
ARG VCS_URL
ARG VCS_REF
ARG NAME
ARG VENDOR

# Metadata