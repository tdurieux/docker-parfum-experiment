# Stage to build the driver
FROM golang:1.18 as builder
RUN mkdir -p /go/src
COPY csi-unity/ /go/src/csi-unity

WORKDIR /go/src/csi-unity
RUN mkdir -p bin
RUN go generate
RUN GOOS=linux CGO_ENABLED=0 GOARCH=amd64 go build -ldflags '-extldflags "-static"' -o bin/csi-unity
# Print the version
RUN go run core/semver/semver.go -f mk

# Dockerfile to build Unity CSI Driver
FROM registry.access.redhat.com/ubi8/ubi-minimal@sha256:9a81cce19ae2a962269d4a7fecd38aec60b852118ad798a265c3f6c4be0df610 as driver
# dependencies, following by cleaning the cache
RUN microdnf update -y \
	&& \
	microdnf install -y e2fsprogs xfsprogs nfs-utils device-mapper-multipath hostname \
    && \
    microdnf clean all \
    && \
    rm -rf /var/cache/run
COPY --from=builder /go/src/csi-unity/bin/csi-unity /
COPY csi-unity/scripts/run.sh /
RUN chmod 777 /run.sh
ENTRYPOINT ["/run.sh"]

RUN microdnf install -y tar

# final stage