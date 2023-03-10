FROM golang:1.14-stretch AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/tradelogs/cmd/trade-logs-crawler
RUN go build -v -mod=mod -o /trade-logs-crawler

FROM debian:stretch
COPY --from=build-env /trade-logs-crawler /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/trade-logs-crawler"]
