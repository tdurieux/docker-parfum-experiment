# Dockerfile to build PowerStore CSI Driver
# based on UBI-minimal image
# Requires: RHEL host with subscription
# UBI Image: ubi8/ubi-minimal:8.6-751
FROM registry.access.redhat.com/ubi8/ubi-minimal@sha256:e83a3146aa8d34dccfb99097aa79a3914327942337890aa6f73911996a80ebb8

LABEL vendor="Dell Inc." \
      name="csi-powerstore" \
      summary="CSI Driver for Dell EMC PowerStore" \
      description="CSI Driver for provisioning persistent storage from Dell EMC PowerStore" \
      version="2.3.0" \
      license="Apache-2.0"

COPY licenses /licenses

# dependencies, following by cleaning the cache
RUN microdnf update -y \
    && \
    microdnf install -y  \
	e2fsprogs \
	xfsprogs \
	nfs-utils \
    nfs4-acl-tools \
    acl \
	which \
	device-mapper-multipath \
	&& \
	microdnf clean all

# validate some cli utilities are found