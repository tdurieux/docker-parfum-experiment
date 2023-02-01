### source build ###
FROM golang:1.14-alpine3.12 as build

COPY src /src

WORKDIR /src

RUN set -ex;\
    CGO_ENABLED=0 GOOS=linux go build -v -o /files/usr/local/bin/beemesh

### runtime build ###
FROM alpine:3.15

COPY --from=build /files /

CMD ["/usr/local/bin/beemesh"]
