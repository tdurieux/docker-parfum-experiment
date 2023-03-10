### Release image
FROM alpine:3.16.0@sha256:686d8c9dfa6f3ccfc8230bc3178d23f84eeaf7e457f36f271ab1acc53015037c

LABEL org.opencontainers.image.source="https://github.com/patrickhoefler/dockerfilegraph"

RUN apk add --update --no-cache \
  graphviz \
  ttf-freefont \
  \
  # Add a non-root user
  && adduser -D app

# Run as non-root user
USER app

# This currently only works with goreleaser
# or if you manually copy the binary into the main project directory