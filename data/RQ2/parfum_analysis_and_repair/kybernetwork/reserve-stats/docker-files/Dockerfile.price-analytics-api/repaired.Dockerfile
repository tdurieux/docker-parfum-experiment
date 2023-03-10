FROM golang:1.14-stretch AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/priceanalytics/cmd/price-analytics-api
RUN go build -v -mod=mod -o /price-analytics-api

FROM debian:stretch
COPY --from=build-env /price-analytics-api /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENV HTTP_ADDRESS=0.0.0.0:8006
EXPOSE 8006
ENTRYPOINT ["/price-analytics-api"]
