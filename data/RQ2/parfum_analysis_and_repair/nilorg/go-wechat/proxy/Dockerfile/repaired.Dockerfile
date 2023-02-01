#build stage
FROM nilorg/golang:1.16.4 AS builder
WORKDIR /src
COPY . .
RUN go build -o ./bin/app -i ./proxy/main.go

#final stage