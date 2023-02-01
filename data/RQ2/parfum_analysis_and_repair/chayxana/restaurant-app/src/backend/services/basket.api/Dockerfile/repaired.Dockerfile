#build stage
FROM golang:1.17-alpine AS builder

RUN apk add --no-cache git

WORKDIR /src
COPY ./go.mod ./go.sum ./

ENV GOPROXY=https://proxy.golang.org
ENV GOSUMDB=sum.golang.org
ENV GO111MODULE=on
RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -installsuffix 'static'
RUN CGO_ENABLED=0 go test -c ./handlers -o handlers.test -cover

#final stage