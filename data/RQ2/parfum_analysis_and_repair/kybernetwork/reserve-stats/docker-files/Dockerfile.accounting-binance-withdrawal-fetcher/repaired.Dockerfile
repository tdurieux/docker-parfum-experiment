FROM golang:1.17 AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/accounting/cmd/accounting-binance-withdrawal-fetcher
RUN go build -v -mod=mod -o /accounting-binance-withdrawal-fetcher

FROM debian:stretch
COPY --from=build-env /accounting-binance-withdrawal-fetcher /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/accounting-binance-withdrawal-fetcher"]
