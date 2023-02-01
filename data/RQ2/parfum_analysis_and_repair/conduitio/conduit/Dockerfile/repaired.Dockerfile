# Start with a golang base
FROM golang:1.18 AS base

# Install core tools
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl && \
    apt-get install --no-install-recommends -y build-essential && \
    apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# Install Node@v16
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm update && \
    npm i -g yarn@1.22.17 && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# Build the full app binary
WORKDIR /app
COPY . .
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 make build

# Copy built binaries to production slim image.
FROM alpine:3.14 AS final
# HTTP API
EXPOSE 8080/tcp
# gRPC API
EXPOSE 8084/tcp
WORKDIR /app
COPY --from=base /app/conduit /app
CMD ["/app/conduit"]
