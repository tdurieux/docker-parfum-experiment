FROM centos:7

LABEL description="image with dependencies to make titan2d"

# setup entry point
WORKDIR /root

# install dependencies
RUN \
    yum -y update && \
    yum -y install --setopt=tsflags=nodocs epel-release && \
    yum -y install --setopt=tsflags=nodocs \
        vim wget git \
        gcc gcc-c++ make autoconf automake \
        python python-devel swig3 \
        hdf5 hdf5-devel gdal gdal-devel\
        java-1.7.0-openjdk java-1.7.0-openjdk-devel \
        isomd5sum time mc && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    sh ./Miniconda3-latest-Linux-x86_64.sh -b && \
    rm ./Miniconda3-latest-Linux-x86_64.sh && \
    ~/miniconda3/bin/conda init && rm -rf /var/cache/yum

RUN ~/miniconda3/bin/conda install -y h5py
