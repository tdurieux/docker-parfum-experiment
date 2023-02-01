FROM golang:alpine AS build-env

# Set up dependencies
ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev python2

# Set working directory for the build
WORKDIR /go/src/github.com/peggyjv/sommelier

# Add source files
COPY . .

# Install minimum necessary dependencies, build Cosmos SDK, remove packages
RUN apk add --no-cache $PACKAGES && \
    make install

# Final image
FROM alpine:edge

# Install ca-certificates
RUN apk add --no-cache --update ca-certificates
WORKDIR /root

# Copy over binaries from the build-env
COPY --from=build-env /go/bin/sommelier /usr/bin/sommelier

COPY ./contrib/single-node.sh .

EXPOSE 26657

ENTRYPOINT [ "./single-node.sh" ]
# NOTE: to run this image, docker run -d -p 26657:26657 ./single-node.sh {{chain_id}} {{genesis_account}}
