FROM centos:6.7

ENV HOME /root
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN yum install -y \
    bzip2 \
    bzip2-devel \
    centos-release-scl \
    cmake \
    curl \
    devtoolset-8-gcc \
    devtoolset-3-binutils \
    devtoolset-8-gcc-c++ \
    devtoolset-8-gcc-gfortran \
    git \
    gzip \
    java-1.8.0-openjdk \
    ncurses-devel \ 
    perl \
    tar \
    wget \
    which \
    zlib-devel \
    
RUN yum upgrade -y && yum update -y && yum clean all && rm -rf /var/cache/yum

RUN mkdir -p /opt/illumina/haplocompare && \
     cd /opt/illumina/haplocompare && \
     wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
     bash Miniconda2-latest-Linux-x86_64.sh -b -p /opt/miniconda2

ENV PATH /opt/miniconda2/bin:${PATH}

RUN conda config --add channels bioconda && \
    conda install -y cython numpy scipy biopython matplotlib pandas pysam bx-python pyvcf cyvcf2 nose

COPY . /opt/illumina/haplocompare/hap.py-source
WORKDIR /opt/illumina/haplocompare/hap.py-source

# patch samtools for centos 6
RUN cd external && \
     tar xvzf samtools.tar.gz && \
     cd samtools && \
     cat Makefile | sed 's/-ldl/-ldl -ltinfo/' > Makefile.bak && \
     mv -f Makefile.bak Makefile && \
     cd .. && \
     rm -f samtools.tar.gz && \
     tar czvf samtools.tar.gz samtools

# get + install ant
WORKDIR /opt
RUN wget https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.7-bin.tar.gz && \
    tar xzf apache-ant-1.9.7-bin.tar.gz && \
    rm apache-ant-1.9.7-bin.tar.gz
ENV PATH $PATH:/opt/apache-ant-1.9.7/bin

RUN  mkdir -p /opt/illumina/haplocompare/data && \
     cd /opt/illumina/haplocompare/data && \
     bash /opt/illumina/haplocompare/hap.py-source/src/sh/make_hg19.sh

ENV HG19 /opt/illumina/haplocompare/data/hg19.fa

WORKDIR /opt/illumina/haplocompare/hap.py-source
RUN scl enable devtoolset-3 'python install.py /opt/illumina/haplocompare/hap.py --with-rtgtools'
