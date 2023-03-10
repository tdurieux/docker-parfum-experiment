# Production deployment spec for query cache service.

# Base golang 1.14 image.
FROM gcr.io/gcp-runtimes/go1-builder:1.14 as builder

RUN apt-get update && apt-get install --no-install-recommends -qy --no-install-suggests git && rm -rf /var/lib/apt/lists/*;
WORKDIR /go/src/wpt.fyi

COPY wpt.fyi .
RUN /usr/local/go/bin/go build -o ../../bin/app ./api/query/cache/service

# Application image.
FROM gcr.io/distroless/base:latest

COPY --from=builder /go/bin/app /usr/local/bin/app

CMD ["/usr/local/bin/app"]
