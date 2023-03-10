FROM golang:1.13.7-alpine

WORKDIR /app

RUN apk add --no-cache git bash

# Install dependencies
COPY go.mod go.sum ./
RUN go mod download

# Verify dependencies
RUN go mod verify

COPY . .

CMD ["go", "run", "main.go", "start"]