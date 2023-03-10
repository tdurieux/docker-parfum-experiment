FROM golang:1.14-stretch AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/reserverates/cmd/reserve-rates-api
RUN go build -v -mod=mod -o /reserve-rates-api

FROM debian:stretch
COPY --from=build-env /reserve-rates-api /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENV HTTP_ADDRESS=0.0.0.0:8003
EXPOSE 8003
ENTRYPOINT ["/reserve-rates-api"]
