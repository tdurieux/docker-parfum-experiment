FROM golang:1.14-stretch AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/accounting/cmd/accounting-reserve-rate-fetcher
RUN go build -v -mod=mod -o /accounting-reserve-rate-fetcher

FROM debian:stretch
COPY --from=build-env /accounting-reserve-rate-fetcher /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/accounting-reserve-rate-fetcher"]
