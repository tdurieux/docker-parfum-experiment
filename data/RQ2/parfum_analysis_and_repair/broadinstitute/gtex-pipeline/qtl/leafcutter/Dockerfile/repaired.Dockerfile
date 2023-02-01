# Dockerfile for LeafCutter
FROM ubuntu:18.04
MAINTAINER Francois Aguet
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && \
    apt-get update && apt-get install --no-install-recommends -y \
        build-essential \
        cmake \
        curl \
        lbzip2 \
        libboost-all-dev \
        libcurl3-dev \
        libgsl-dev \
        libssl-dev \
        libxml2-dev \
        openjdk-8-jdk \
        python3 \
        python3-pip \
        r-base-core \
        unzip \
        vim-common \
        wget \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

# R
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile && \
    Rscript -e "install.packages(c('argparser', 'devtools'), dependencies=TRUE)" && \
    Rscript -e 'source("http://bioconductor.org/biocLite.R"); biocLite("qvalue"); biocLite("sva"); biocLite("edgeR");'

# htslib
RUN cd /opt && \
    wget --no-check-certificate https://github.com/samtools/htslib/releases/download/1.15/htslib-1.15.tar.bz2 && \
    tar -xf htslib-1.15.tar.bz2 && rm htslib-1.15.tar.bz2 && cd htslib-1.15 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-libcurl --enable-s3 --enable-plugins --enable-gcs && \
    make && make install && make clean

# samtools
RUN cd /opt && \
    wget --no-check-certificate https://github.com/samtools/samtools/releases/download/1.15/samtools-1.15.tar.bz2 && \
    tar -xf samtools-1.15.tar.bz2 && rm samtools-1.15.tar.bz2 && cd samtools-1.15 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-htslib=/opt/htslib-1.15 && make && make install && make clean

# bcftools
RUN cd /opt && \
    wget --no-check-certificate https://github.com/samtools/bcftools/releases/download/1.15/bcftools-1.15.tar.bz2 && \
    tar -xf bcftools-1.15.tar.bz2 && rm bcftools-1.15.tar.bz2 && cd bcftools-1.15 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-htslib=/opt/htslib-1.15 && make && make install && make clean

# Python 3
RUN pip3 install --no-cache-dir --upgrade pip setuptools
RUN pip3 install --no-cache-dir numpy tables pandas scipy scikit-learn matplotlib qtl

# LeafCutter
RUN cd /opt && \
    wget https://github.com/francois-a/leafcutter/archive/2488118d377baff3354dab85de1f31b03a813c92.tar.gz && \
    tar -xf 2488118d377baff3354dab85de1f31b03a813c92.tar.gz && \
    rm 2488118d377baff3354dab85de1f31b03a813c92.tar.gz && \
    ln -s leafcutter-2488118d377baff3354dab85de1f31b03a813c92 leafcutter

# regtools
RUN cd /opt && \
    wget https://github.com/griffithlab/regtools/archive/refs/tags/0.5.2.zip && \
    unzip 0.5.2.zip && rm 0.5.2.zip && cd regtools-0.5.2 && mkdir build && cd build && \
    cmake .. && make && mv regtools .. && make clean
ENV PATH /opt/regtools-0.5.2:$PATH

# copy scripts
COPY src src/
