# some arguments that must be supplied
ARG GOPROXY
ARG GOVERSION
ARG BASEIMAGE

# Stage to build the driver
FROM golang:${GOVERSION} as builder
ARG GOPROXY
RUN mkdir -p /go/src
COPY ./ /go/src/
WORKDIR /go/src/
RUN CGO_ENABLED=0 \
    make build

# Stage to build the driver image
FROM $BASEIMAGE AS driver
# install necessary packages
# alphabetical order for easier maintenance
RUN microdnf update -y && \
        microdnf install -y \
        e4fsprogs \
        libaio \
        libuuid \
        nfs-utils \
        numactl \
        xfsprogs && \
    microdnf clean all
# copy in the driver
COPY --from=builder /go/src/csi-isilon /
ENTRYPOINT ["/csi-isilon"]

# final stage
# simple stage to use the driver image as the resultant image