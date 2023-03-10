#build stage
FROM golang:1.11.5-alpine3.9 AS builder
RUN apk add --no-cache git
WORKDIR /go/src/github.com/dgkanatsios/azuregameserversscalingkubernetes
COPY . .
RUN cd ./cmd/controller 
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /build/controller ./cmd/controller

#final stage