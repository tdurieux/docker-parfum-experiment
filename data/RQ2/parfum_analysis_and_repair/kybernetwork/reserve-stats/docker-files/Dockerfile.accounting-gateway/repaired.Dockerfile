FROM golang:1.14-stretch AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/accounting/cmd/accounting-gateway
RUN go build -v -mod=mod -o /accounting-gateway

FROM debian:stretch
COPY --from=build-env /accounting-gateway /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENV HTTP_ADDRESS=0.0.0.0:8016
EXPOSE 8016

ENTRYPOINT ["/accounting-gateway"]
