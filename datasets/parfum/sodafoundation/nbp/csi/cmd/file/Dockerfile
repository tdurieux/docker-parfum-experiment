# Based on ubuntu
FROM ubuntu:xenial
LABEL maintainers="Edison Xiang <xiang.edison@gmail.com>"
LABEL description="OpenSDS CSI file Plugin"

# Copy opensdsplugin from build directory
COPY csi.file.opensds /csi.file.opensds

COPY nvme-cli-1.8.1  /nvme-cli-1.8.1

# Install iscsi
RUN apt-get update && \
    apt-get --no-install-recommends -y install open-iscsi \
    sysfsutils \
    kmod \
    ceph-common \
    nfs-common \
    gawk \
    iputils-ping  \
    dmidecode &&\
    rm -rf /var/lib/apt/lists/* &&\ 
    # install nvme cli 
    install -d /usr/local/sbin && install -m 755 /nvme-cli-1.8.1/nvme /usr/local/sbin


# Define default command
ENTRYPOINT ["/csi.file.opensds"]
