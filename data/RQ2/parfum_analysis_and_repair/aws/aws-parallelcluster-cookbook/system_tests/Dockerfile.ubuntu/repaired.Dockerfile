FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV KERNEL_RELEASE 5.11.0-1017-aws

# prep env so that required packages are cached
RUN apt-get -y update && apt upgrade -y && \
    apt-get -y --no-install-recommends install sudo build-essential curl wget jq nfs-common nfs-kernel-server udev && rm -rf /var/lib/apt/lists/*;

# get packages that will be installed during bootstrapping
RUN apt-get -y --no-install-recommends install vim ksh tcsh zsh libssl-dev ncurses-dev libpam-dev net-tools \
               libhwloc-dev dkms tcl-dev automake autoconf libtool librrd-dev \
               libapr1-dev libconfuse-dev apache2 libboost-dev libdb-dev tcsh \
               libncurses5-dev libpam0g-dev libxt-dev libmotif-dev libxmu-dev \
               libxft-dev libhwloc-dev man-db lvm2 python r-base libblas-dev \
               libffi-dev libxml2-dev mdadm libgcrypt20-dev libmysqlclient-dev \
               libevent-dev iproute2 python3 python3-pip libatlas-base-dev \
               libglvnd-dev linux-headers-aws iptables libcurl4-openssl-dev \
               python3-parted && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install binutils-doc bison flex gettext libsqlite3-dev llvm openssh-server \
               libncursesw5-dev tk-dev python-openssl git apt-transport-https && rm -rf /var/lib/apt/lists/*;

# required for EFA
RUN apt-get -y --no-install-recommends install ethtool ibacm ibverbs-providers ibverbs-utils \
               infiniband-diags libibmad-dev libibmad5 libibnetdisc-dev \
               libibnetdisc5 libibumad-dev libibumad3 libibverbs-dev libibverbs1 \
               librdmacm-dev librdmacm1 rdma-core rdmacm-utils cmake cmake-data && rm -rf /var/lib/apt/lists/*;

# required for DCV
RUN apt-get -y --no-install-recommends install whoopsie && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ubuntu-desktop mesa-utils && rm -rf /var/lib/apt/lists/*;

# install kernel modules / image for EFA installation
RUN mkdir -p /lib/modules/${KERNEL_RELEASE} && \
    apt-get -y --no-install-recommends install linux-modules-${KERNEL_RELEASE} && \
    apt-get -y --no-install-recommends install linux-image-${KERNEL_RELEASE} && rm -rf /var/lib/apt/lists/*;

WORKDIR build

# install CINC
COPY system_tests/install_cinc.sh install_cinc.sh
RUN ./install_cinc.sh

# customization for build for docker environment
COPY . /tmp/cookbooks

COPY system_tests/bootstrap.sh bootstrap.sh
RUN ./bootstrap.sh
