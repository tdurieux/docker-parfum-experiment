# Build Stage
################################################################################
FROM golang:1.17-bullseye as builder

WORKDIR /builder

# Download & compile dependencies early. Doing this separately allows for layer
# caching opportunities when no dependencies are updated.
COPY go.* ./
RUN go mod download

# Build the connector projects we depend on.
COPY materialize-boilerplate ./materialize-boilerplate
COPY go-schema-gen           ./go-schema-gen
COPY materialize-elasticsearch ./materialize-elasticsearch

# TODO: copy flow bins
# Copy schema-builder binary.
COPY flow-bin/flow-schemalate ./

ENV PATH="/builder:$PATH"
# Test and build the connector.
RUN go test  -tags nozstd -v ./materialize-elasticsearch/...
RUN go build -tags nozstd -v -o ./connector ./materialize-elasticsearch

# Runtime Stage
################################################################################
FROM ghcr.io/estuary/base-image:v1

WORKDIR /connector
ENV PATH="/connector:$PATH"

# Bring in the compiled connector artifact from the builder.
COPY --from=builder /builder/connector /connector/
COPY --from=builder /builder/flow-schemalate /connector/
COPY --from=builder /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/x86_64-linux-gnu/

# Avoid running the connector as root.