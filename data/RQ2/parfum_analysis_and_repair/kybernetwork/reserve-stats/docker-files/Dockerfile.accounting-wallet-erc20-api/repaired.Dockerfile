FROM golang:1.14-stretch AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/accounting/cmd/accounting-wallet-erc20-api
RUN go build -v -mod=mod -o /accounting-wallet-erc20-api

FROM debian:stretch
COPY --from=build-env /accounting-wallet-erc20-api /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENV HTTP_ADDRESS=0.0.0.0:8012
EXPOSE 8012

ENTRYPOINT ["/accounting-wallet-erc20-api"]
