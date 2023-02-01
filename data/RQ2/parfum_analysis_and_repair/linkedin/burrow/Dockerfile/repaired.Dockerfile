# stage 1: builder
FROM golang:1.17.6-alpine as builder

ENV BURROW_SRC /usr/src/Burrow/

RUN apk add --no-cache git curl
COPY . $BURROW_SRC
WORKDIR $BURROW_SRC

RUN go mod tidy && go build -o /tmp/burrow .

# stage 2: runner