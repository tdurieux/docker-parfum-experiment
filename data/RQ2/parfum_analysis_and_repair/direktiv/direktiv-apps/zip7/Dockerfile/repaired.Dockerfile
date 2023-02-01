FROM golang:1.16.13-buster as build

WORKDIR /app
COPY ./main.go /app
COPY ./go.mod /app
COPY ./go.sum /app

RUN go get -u -v
RUN CGO_ENABLED=0 go build -o /zip -ldflags="-s -w" main.go

FROM alpine:latest as certs
RUN apk --update --no-cache add ca-certificates

FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends p7zip-full -y && rm -rf /var/lib/apt/lists/*;

COPY --from=build /zip /
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
CMD ["/zip"]
