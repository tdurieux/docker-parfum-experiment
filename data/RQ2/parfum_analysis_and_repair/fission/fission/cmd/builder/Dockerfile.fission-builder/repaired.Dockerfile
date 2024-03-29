FROM alpine:3.16
RUN apk add --no-cache --update ca-certificates
COPY builder /builder
ENTRYPOINT ["/builder"]
