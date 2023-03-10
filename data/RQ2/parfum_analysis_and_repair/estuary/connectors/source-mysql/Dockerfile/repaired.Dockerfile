# Build Stage
################################################################################
FROM golang:1.17-buster as builder

WORKDIR /builder

# Download & compile dependencies early. Doing this separately allows for layer
# caching opportunities when no dependencies are updated.
COPY go.* ./
RUN go mod download

# Build the connector projects we depend on.
COPY source-mysql  ./source-mysql
COPY go-schema-gen ./go-schema-gen
COPY sqlcapture    ./sqlcapture

# Run the unit tests.
RUN go test -v ./source-mysql/...

# Build the connector.
RUN go build -o ./connector -v ./source-mysql/...


# Runtime Stage
################################################################################
FROM ghcr.io/estuary/base-image:v1

WORKDIR /connector
ENV PATH="/connector:$PATH"

COPY --from=busybox:latest /bin/sh /bin/sh

# Bring in the compiled connector artifact from the builder.
COPY --from=builder /builder/connector ./connector

# Avoid running the connector as root.