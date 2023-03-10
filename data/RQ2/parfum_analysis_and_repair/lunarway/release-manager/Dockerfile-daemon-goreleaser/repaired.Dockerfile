FROM alpine:3.16.0 as builder

RUN apk update
RUN apk add --no-cache ca-certificates

FROM scratch
ENTRYPOINT [ "/daemon", "start" ]
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY daemon /
