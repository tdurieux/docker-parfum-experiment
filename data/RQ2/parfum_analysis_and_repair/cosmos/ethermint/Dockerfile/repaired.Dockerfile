FROM golang:alpine AS build-env

# Set up dependencies
ENV PACKAGES git build-base

# Set working directory for the build
WORKDIR /go/src/github.com/cosmos/ethermint

# Install dependencies
RUN apk add --no-cache --update $PACKAGES
RUN apk add --no-cache linux-headers

# Add source files
COPY . .

# Make the binary
RUN make build

# Final image
FROM alpine

# Install ca-certificates
RUN apk add --no-cache --update ca-certificates jq
WORKDIR /root

# Copy over binaries from the build-env
COPY --from=build-env /go/src/github.com/cosmos/ethermint/build/ethermintd /usr/bin/ethermintd
COPY --from=build-env /go/src/github.com/cosmos/ethermint/build/ethermintcli /usr/bin/ethermintcli

# Run ethermintd by default
CMD ["ethermintd"]
