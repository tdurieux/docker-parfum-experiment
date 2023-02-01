FROM alpine:latest as builder

RUN apk --update --no-cache add ca-certificates

FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY autobot /

ENTRYPOINT ["/autobot"]
