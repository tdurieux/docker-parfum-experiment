FROM golang:1.14-stretch AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/accounting/cmd/accounting-listed-token-fetcher
RUN go build -v -mod=mod -o /accounting-listed-token-fetcher

FROM debian:stretch
COPY --from=build-env /accounting-listed-token-fetcher /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/accounting-listed-token-fetcher"]
