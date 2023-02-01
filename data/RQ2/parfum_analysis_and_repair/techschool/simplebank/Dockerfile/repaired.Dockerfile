# Build stage
FROM golang:1.18-alpine3.15 AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go

# Run stage