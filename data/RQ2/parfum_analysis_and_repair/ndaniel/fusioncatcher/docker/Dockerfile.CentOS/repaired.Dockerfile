FROM centos:7.6.1810

LABEL Description="This image is used to run FusionCatcher" Version="1.30"

RUN yum install -y epel-release \
    && yum install -y \
    automake \
    which \
    git \
    bzip2 \
    cmake \
    curl \
    gawk \
    gcc \
    gzip  \
    ncurses \
    ncurses-devel \
    make \
    pigz \
    tar \
    unzip \
    wget \
    zlib-devel \
    java-1.8.0-openjdk* \
    tbb-devel \
    glibc-devel \
    python-devel \
    numpy \
    python-biopython \
    && wget --no-check-certificate https://sf.net/projects/fusioncatcher/files/bootstrap.py -O bootstrap.py \
    && python bootstrap.py --help \
    && python bootstrap.py -t -y -i /opt/fusioncatcher/v1.30/ && rm -rf /var/cache/yum

WORKDIR /opt

