FROM golang:1.14-stretch AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/accounting/cmd/accounting-reserve-rates-api
RUN go build -v -mod=mod -o /accounting-reserve-rates-api

FROM debian:stretch
COPY --from=build-env /accounting-reserve-rates-api /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENV HTTP_ADDRESS=0.0.0.0:8015
EXPOSE 8015

ENTRYPOINT ["/accounting-reserve-rates-api"]
