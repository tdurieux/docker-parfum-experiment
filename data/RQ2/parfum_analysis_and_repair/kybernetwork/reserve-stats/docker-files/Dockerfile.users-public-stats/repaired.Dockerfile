FROM golang:1.14-stretch AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/users/cmd/users-public-stats
RUN go build -v -mod=mod -o /users-public-stats

FROM debian:stretch
COPY --from=build-env /users-public-stats /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENV HTTP_ADDRESS=0.0.0.0:8008
EXPOSE 8008
ENTRYPOINT ["/users-public-stats"]
