FROM golang:1.14-stretch AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/tokenratefetcher/cmd
RUN go build -v -mod=mod -o /token-rate-fetcher

FROM debian:stretch
COPY --from=build-env /token-rate-fetcher /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/token-rate-fetcher"]
