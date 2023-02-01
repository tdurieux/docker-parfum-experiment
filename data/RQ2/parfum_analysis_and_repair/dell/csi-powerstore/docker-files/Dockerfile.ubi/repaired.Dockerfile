# Dockerfile to build PowerStore CSI Driver
# based on standard UBI image
# Requires: RHEL host with subscription
FROM registry.access.redhat.com/ubi8/ubi:latest

LABEL vendor="Dell Inc." \
      name="csi-powerstore" \
      summary="CSI Driver for Dell EMC PowerStore" \
      description="CSI Driver for provisioning persistent storage from Dell EMC PowerStore" \
      version="2.3.0" \
      license="Apache-2.0"

COPY licenses /licenses

# dependencies, following by cleaning the cache
RUN yum update -y \
    && \
    yum install -y e2fsprogs xfsprogs nfs-utils nfs4-acl-tools acl which device-mapper-multipath \
    && \
    yum clean all \
    && \
    rm -rf /var/cache/run && rm -rf /var/cache/yum

# validate some cli utilities are found
RUN which mkfs.ext4
RUN which mkfs.xfs
RUN echo "export PATH=$PATH:/sbin:/bin" > /etc/profile.d/ubuntu_path.sh

COPY "csi-powerstore" .
ENTRYPOINT ["/csi-powerstore"]
