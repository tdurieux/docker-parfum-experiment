############################################################
# Build image
############################################################
FROM golang:1.18-alpine as builder

ARG VERSION
ARG BUILT_AT
ARG COMMIT

RUN apk update && apk add --no-cache git ca-certificates && update-ca-certificates

WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build \
    -ldflags="-w -s \
    -X main.version=$VERSION \
    -X main.commit=$COMMIT \
    -X main.builtAt=$BUILT_AT" \
    -o ./bin/kminion

############################################################
# Runtime Image
############################################################