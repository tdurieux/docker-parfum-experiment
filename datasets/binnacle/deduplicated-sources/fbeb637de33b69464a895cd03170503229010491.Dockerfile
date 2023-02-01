FROM golang:1.11.4-alpine3.8

WORKDIR /

COPY ./ ./go/src/github.com/MarioCarrion/nit

RUN CGO_ENABLED=0 GOOS=linux go build --ldflags="-s" -a -installsuffix cgo -o /go/bin/nit ./go/src/github.com/MarioCarrion/nit/cmd/nit
