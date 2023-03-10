FROM golang:1.14-stretch AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/burnedfees/cmd/burned-fees-crawler
RUN go build -v -mod=mod -o /burned-fees-crawler

FROM debian:stretch
COPY --from=build-env /burned-fees-crawler /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/burned-fees-crawler"]
