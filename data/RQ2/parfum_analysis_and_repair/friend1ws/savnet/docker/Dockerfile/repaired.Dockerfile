FROM ubuntu:16.04
MAINTAINER Yuichi Shiraishi <friend1ws@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    wget \
    bzip2 \
    make \
    gcc \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    python \
    python-pip && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/samtools/htslib/releases/download/1.7/htslib-1.7.tar.bz2 && \
    tar -jxvf htslib-1.7.tar.bz2 && \
    cd htslib-1.7 && make && make install && rm htslib-1.7.tar.bz2

RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.27.0/bedtools-2.27.0.tar.gz && \
    tar -zxvf bedtools-2.27.0.tar.gz && \
    cd bedtools2 && make && make install && rm bedtools-2.27.0.tar.gz

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade setuptools

RUN pip install --no-cache-dir pysam==0.13
RUN pip install --no-cache-dir annot_utils==0.2.1
RUN pip install --no-cache-dir junc_utils==0.4.1
RUN pip install --no-cache-dir intron_retention_utils==0.5.1
RUN pip install --no-cache-dir chimera_utils==0.5.1
RUN pip install --no-cache-dir savnet==0.3.2

