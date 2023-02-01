# Dockerfile for tensorQTL
FROM nvidia/cuda:10.2-cudnn7-runtime-ubuntu18.04
MAINTAINER Francois Aguet

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && \
    apt-get update && apt-get install --no-install-recommends -y \
        apt-transport-https \
        build-essential \
        cmake \
        curl \
        libboost-all-dev \
        libbz2-dev \
        libcurl3-dev \
        liblzma-dev \
        libncurses5-dev \
        libssl-dev \
        python3 \
        python3-pip \
        sudo \
        unzip \
        wget \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

# htslib
RUN cd /opt && \
    wget --no-check-certificate https://github.com/samtools/htslib/releases/download/1.10.2/htslib-1.10.2.tar.bz2 && \
    tar -xf htslib-1.10.2.tar.bz2 && rm htslib-1.10.2.tar.bz2 && cd htslib-1.10.2 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-libcurl --enable-s3 --enable-plugins --enable-gcs && \
    make && make install && make clean

# bcftools
RUN cd /opt && \
    wget --no-check-certificate https://github.com/samtools/bcftools/releases/download/1.10.2/bcftools-1.10.2.tar.bz2 && \
    tar -xf bcftools-1.10.2.tar.bz2 && rm bcftools-1.10.2.tar.bz2 && cd bcftools-1.10.2 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-htslib=system && make && make install && make clean

# install R
ENV DEBIAN_FRONTEND noninteractive
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'
RUN apt update && apt install --no-install-recommends -y r-base r-base-dev && rm -rf /var/lib/apt/lists/*;
ENV R_LIBS_USER=/opt/R/3.6
RUN Rscript -e 'if (!requireNamespace("BiocManager", quietly = TRUE)) {install.packages("BiocManager")}; BiocManager::install("qvalue");'

# python modules
RUN pip3 install --no-cache-dir --upgrade pip setuptools
RUN pip3 install --no-cache-dir numpy pandas scipy
RUN pip3 install --no-cache-dir pandas-plink ipython jupyter matplotlib pyarrow torch rpy2 gcsfs

RUN cd /opt && \
    wget https://github.com/broadinstitute/tensorqtl/archive/v1.0.7.tar.gz && \
    tar -xf v1.0.7.tar.gz && mv tensorqtl-1.0.7 tensorqtl && \
    rm v1.0.7.tar.gz
RUN pip3 install --no-cache-dir -e /opt/tensorqtl/
