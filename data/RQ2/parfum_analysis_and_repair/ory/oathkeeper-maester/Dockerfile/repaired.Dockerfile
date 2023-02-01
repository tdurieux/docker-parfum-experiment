# Build the manager binary
FROM golang:1.16 as builder
WORKDIR /go/src/app
COPY . .
RUN apt update && \
    apt install -y --no-install-recommends ca-certificates && \
    make manager && rm -rf /var/lib/apt/lists/*;

FROM gcr.io/distroless/static:latest
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/src/app/manager .
USER 1000

ENTRYPOINT ["/manager"]
