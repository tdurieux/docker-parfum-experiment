FROM golang:1.14-stretch AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/app-names/cmd/app-names-api
RUN go build -v -mod=mod -o /app-names-api

FROM debian:stretch
COPY --from=build-env /app-names-api /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENV HTTP_ADDRESS=0.0.0.0:8007
EXPOSE 8005
ENTRYPOINT ["/app-names-api"]
