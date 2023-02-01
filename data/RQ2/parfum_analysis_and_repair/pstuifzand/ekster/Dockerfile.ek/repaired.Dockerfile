# build stage
FROM golang:1.10.2-alpine3.7 AS build-env
RUN apk --no-cache add git
RUN go get p83.nl/go/ekster/cmd/ek

# final stage