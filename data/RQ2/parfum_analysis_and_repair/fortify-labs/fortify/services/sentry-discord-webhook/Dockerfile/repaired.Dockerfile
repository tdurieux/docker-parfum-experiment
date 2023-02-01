# --- Build image ---
FROM golang:1.15.4-alpine AS build

RUN apk --no-cache add ca-certificates git make bash

WORKDIR /src/sentry-discord-webhook
COPY . .

ENV CGO_ENABLED=0
ENV GOOS=linux
RUN make

# --- Execution image ---