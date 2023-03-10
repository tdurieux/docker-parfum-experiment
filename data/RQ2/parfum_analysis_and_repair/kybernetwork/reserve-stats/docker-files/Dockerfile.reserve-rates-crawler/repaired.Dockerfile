FROM golang:1.14-stretch AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/reserverates/cmd/reserve-rates-crawler
RUN go build -v -mod=mod -o /reserve-rates-crawler

FROM debian:stretch
COPY --from=build-env /reserve-rates-crawler /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/reserve-rates-crawler"]
