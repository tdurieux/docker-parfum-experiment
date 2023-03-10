FROM alpine:3.7 AS builder

RUN apk add --update --no-cache ca-certificates


FROM alpine:3.7

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ARG BUILD_DIR
ARG BINARY_NAME

COPY $BUILD_DIR/$BINARY_NAME /app
USER nobody:nobody
CMD ["/app"]