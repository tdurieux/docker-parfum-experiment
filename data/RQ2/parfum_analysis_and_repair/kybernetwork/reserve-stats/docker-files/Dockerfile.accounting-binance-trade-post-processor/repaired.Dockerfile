FROM golang:1.15 AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/accounting/cmd/accounting-binance-trade-post-processor
RUN go build -v -mod=mod -o /accounting-binance-trade-post-processor

FROM debian:stretch
COPY --from=build-env /accounting-binance-trade-post-processor /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/accounting-binance-trade-post-processor"]
