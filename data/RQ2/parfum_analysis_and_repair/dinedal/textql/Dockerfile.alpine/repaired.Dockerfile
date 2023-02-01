FROM golang:1.10-alpine3.7 AS build

# "build-base" for gcc
RUN apk update && apk add --no-cache git && apk add --no-cache build-base
WORKDIR /go/src/app
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

FROM alpine:3.7
RUN apk add --no-cache --update-cache sqlite
COPY --from=build /go/bin/textql /usr/bin
WORKDIR /tmp
ENTRYPOINT ["textql"]

