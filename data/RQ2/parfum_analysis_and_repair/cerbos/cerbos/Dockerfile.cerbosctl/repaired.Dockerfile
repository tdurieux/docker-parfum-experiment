FROM alpine:3.15 AS base
RUN apk add -U --no-cache ca-certificates && update-ca-certificates

FROM scratch
ENTRYPOINT ["/cerbosctl"]
COPY --from=base /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY cerbosctl /cerbosctl