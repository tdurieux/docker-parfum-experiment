FROM alpine

RUN apk update && apk add --no-cache ca-certificates

COPY cache-shim /cache-shim

ENTRYPOINT ["/bin/sh", "-c", "/cache-shim && cp /cache-shim cache-shim"]
