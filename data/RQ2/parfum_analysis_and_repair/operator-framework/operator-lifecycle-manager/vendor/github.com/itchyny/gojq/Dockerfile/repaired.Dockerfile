FROM golang:1.14 as builder

WORKDIR /app
COPY . .
ENV CGO_ENABLED 0
RUN make build

FROM alpine:3.12

COPY --from=builder /app/gojq /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/gojq"]
CMD ["--help"]