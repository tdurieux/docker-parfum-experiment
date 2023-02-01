# Step 1:
FROM golang:1.13.5-alpine3.11 AS builder

RUN apk update && apk add --no-cache git make

WORKDIR $GOPATH/src/github.com/Fs02/go-todo-backend
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64\
    go build -mod=vendor -ldflags="-w -s" -o /go/bin/api ./cmd/api

# Step 2:
# you can also use scratch here, but I prefer to use alpine because it comes with basic command such as curl useful for debugging.