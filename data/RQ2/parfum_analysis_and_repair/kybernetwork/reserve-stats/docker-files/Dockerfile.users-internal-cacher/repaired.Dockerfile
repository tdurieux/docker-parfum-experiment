FROM golang:1.14-stretch AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/users/cmd/users-internal-cacher
RUN go build -v -mod=mod -o /users-internal-cacher

FROM debian:stretch
COPY --from=build-env /users-internal-cacher /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/users-internal-cacher"]
