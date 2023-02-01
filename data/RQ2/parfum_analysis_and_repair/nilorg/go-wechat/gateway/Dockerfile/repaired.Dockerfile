#build stage
FROM nilorg/golang:1.16.4 AS builder
WORKDIR /src
COPY . .
RUN go build -o ./bin/app -i ./gateway/main.go

#final stage