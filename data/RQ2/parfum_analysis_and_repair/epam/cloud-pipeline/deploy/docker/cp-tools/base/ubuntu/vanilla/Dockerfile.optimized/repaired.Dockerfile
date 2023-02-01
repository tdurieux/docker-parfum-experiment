ARG BASE_IMAGE=library/ubuntu:20.04
FROM ${BASE_IMAGE}

# Common deps + NFS/CIFS clients
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive \
        apt --no-install-recommends install -y curl \
                        wget \
                        unzip \
                        git \
                        python \
                        fuse \
                        tzdata \
                        acl \
                        coreutils \
                        openssh-server \
                        apt-transport-https \
                        gnupg \
                        lsb-release \
                        kmod \
                        sudo \
                        locales \
                        nfs-common \
                        cifs-utils \
                        btrfs-progs \
                        e2fsprogs \
                        iptables \
                        iproute2 \
                        xfsprogs \
                        xz-utils \
                        pigz \
                        kmod && rm -rf /var/lib/apt/lists/*;

# pip
RUN curl -f -s https://cloud-pipeline-oss-builds.s3.amazonaws.com/tools/pip/2.7/get-pip.py | python2 && \
    python2 -m pip install -I -q setuptools==44.1.1

# Lustre client
RUN wget https://cloud-pipeline-oss-builds.s3.amazonaws.com/tools/lustre/client/deb/lustre-client-ubuntu-1804.tar.gz -O lustre-client.tar.gz && \
    mkdir lustre-client-install/ && \
    tar -C lustre-client-install/ -zxvf lustre-client.tar.gz && \
    mkdir -p /lib/modules/$(uname -r) && \
    (dpkg --unpack lustre-client-install/* && rm -rf /var/lib/dpkg/info/lustre* || true) && \
    apt --fix-broken install -y && \
    rm -rf lustre-client-install/ lustre-client.tar.gz

# Setup S3-based repo for SGE and LFS
RUN source /etc/os-release && \
    curl -f -sk "https://cloud-pipeline-oss-builds.s3.amazonaws.com/tools/repos/cloud-pipeline.key" | apt-key add - && \
    sed -i "1 i\deb https://cloud-pipeline-oss-builds.s3.amazonaws.com/tools/repos/ubuntu/${VERSION_ID} stable main" /etc/apt/sources.list && \
    apt-get update -y

# SGE
ENV CP_CAP_SGE_PREINSTALLED=true
RUN DEBIAN_FRONTEND=noninteractive \
        apt-get --no-install-recommends install -y --allow-unauthenticated -o Dpkg::Options::="--force-confdef" -o \
            gridengine-exec="8.1.9+dfsg-4*" \
            gridengine-client="8.1.9+dfsg-4*" \
            gridengine-common="8.1.9+dfsg-4*" \
            gridengine-master="8.1.9+dfsg-4*" && rm -rf /var/lib/apt/lists/*;

# LizardFS
RUN apt-get install --no-install-recommends -y -t stable lizardfs-client \
                                    lizardfs-chunkserver \
                                    lizardfs-chunkserver && rm -rf /var/lib/apt/lists/*;