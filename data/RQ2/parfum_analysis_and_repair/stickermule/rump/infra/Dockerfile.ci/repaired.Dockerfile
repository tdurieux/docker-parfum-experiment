FROM golang:1.12.4-alpine

# disable cgo to avoid gcc requirement bug
ENV CGO_ENABLED=0

RUN apk update && apk --update add --no-cache git

RUN go get -u golang.org/x/lint/golint

WORKDIR /app
COPY . ./

RUN go mod download