FROM ubuntu:20.04
MAINTAINER Yuichi Shiraishi <friend1ws@gmail.com>
MAINTAINER Kenichi Chiba <kchiba@hgc.jp>

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
    python3-pip && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/samtools/htslib/releases/download/1.11/htslib-1.11.tar.bz2 && \
    tar jxvf htslib-1.11.tar.bz2 && \
    cd htslib-1.11 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install && rm htslib-1.11.tar.bz2

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade setuptools

RUN pip3 install --no-cache-dir annot_utils==0.3.1
RUN pip3 install --no-cache-dir pysam==0.16.0.1
RUN pip3 install --no-cache-dir numpy==1.19.5
RUN pip3 install --no-cache-dir scipy==1.5.4
RUN pip3 install --no-cache-dir genomon_sv==0.8.2
RUN pip3 install --no-cache-dir edlib==1.3.8.post2

# sv_utils
RUN pip3 install --no-cache-dir sv_utils==0.6.1
RUN pip3 install --no-cache-dir primer3-py==0.6.1


