# build stage
FROM golang:1.14-alpine AS build-env
RUN apk --no-cache add git
RUN CGO_ENABLED=0 go get -a -ldflags '-extldflags "-static"' p83.nl/go/ekster/...

# final stage