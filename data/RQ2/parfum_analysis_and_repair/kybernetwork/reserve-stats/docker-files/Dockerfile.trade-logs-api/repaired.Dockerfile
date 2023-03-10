FROM golang:1.14-stretch AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/tradelogs/cmd/trade-logs-api
RUN go build -v -mod=mod -o /trade-logs-api

FROM debian:stretch
COPY --from=build-env /trade-logs-api /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENV HTTP_ADDRESS=0.0.0.0:8004
EXPOSE 8004
ENTRYPOINT ["/trade-logs-api"]
