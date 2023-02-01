FROM golang:1.13 AS builder

WORKDIR /go/src/app
COPY vendor/c-sdk .
RUN make daemon

FROM debian:buster
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app
COPY --from=builder /go/src/app/newrelic-daemon .
CMD ["/usr/src/app/newrelic-daemon", "-f", "--loglevel", "debug", \
     "--logfile", "/var/log/newrelic/newrelic.log"]
