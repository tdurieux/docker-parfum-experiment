FROM alpine:3.15

RUN apk update && apk add --no-cache ca-certificates curl && rm -rf /var/cache/apk/*

ENV GIN_MODE=release

EXPOSE 8080/tcp

HEALTHCHECK --interval=30s --timeout=30s --retries=3 \
    CMD curl -f http://localhost:8080/api/v1/healthz

COPY gose /

ENTRYPOINT ["/gose"]
