# Build Stage
FROM golang:1.18-alpine AS build-env
ADD . /src
RUN apk --no-cache add git \
    && cd /src && go build -v -ldflags "-s -w"

# Final Stage