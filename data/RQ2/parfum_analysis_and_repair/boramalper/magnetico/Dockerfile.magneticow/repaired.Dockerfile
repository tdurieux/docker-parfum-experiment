FROM golang:1.15-alpine AS build
WORKDIR /magnetico

RUN export PATH=$PATH:/go/bin
RUN apk add --no-cache build-base curl git
RUN go get -u github.com/kevinburke/go-bindata/...

ADD ./Makefile        /magnetico/
ADD ./pkg             /magnetico/pkg
ADD ./go.mod          /magnetico/go.mod
ADD ./cmd/magneticow  /magnetico/cmd/magneticow

RUN     make magneticow

FROM alpine:latest
LABEL maintainer="bora@boramalper.org"
EXPOSE 8080
WORKDIR /
VOLUME /root/.local/share/magneticod
VOLUME /root/.config/magneticow

RUN apk add --no-cache libgcc libstdc++

COPY --from=build /go/bin/magneticow /magneticow

ENTRYPOINT ["/magneticow"]