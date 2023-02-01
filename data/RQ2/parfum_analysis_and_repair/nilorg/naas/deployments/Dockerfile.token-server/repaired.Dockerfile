#build stage
FROM nilorg/golang:1.16.4 AS builder
WORKDIR /src
COPY . .
RUN go build -mod=vendor -o ./bin/token-server ./cmd/token-server/main.go

#final stage