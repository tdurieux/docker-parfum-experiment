# Build Stage
FROM golang:alpine as build

WORKDIR /src/Meme_Api

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go build -o /app/Meme_API

# Final Stage