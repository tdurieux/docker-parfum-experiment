FROM ubuntu:16.04
MAINTAINER Steve Tsang <mylagimail2004@yahoo.com>
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes \
 build-essential \
 gcc-multilib \
 apt-utils \
 wget \
 zlib1g-dev \
 vim-common \
 wget \
 libncurses5-dev \
 autotools-dev \
 autoconf \
 git \
 perl \
 r-base \
 python \
 libbz2-dev \
 liblzma-dev \
 libz-dev \
 ncurses-dev \
 zlib1g-dev \
 libcurl3 \
 libcurl4-openssl-dev \
 libxml2-dev


### SUBREAD Ver 1.5 ###
WORKDIR /opt/
RUN wget https://sourceforge.net/projects/subread/files/subread-1.5.2/subread-1.5.2-Linux-x86_64.tar.gz
RUN tar xvzf subread-1.5.2-Linux-x86_64.tar.gz
RUN mv /opt/subread-1.5.2-Linux-x86_64/bin/utilities/* /opt/subread-1.5.2-Linux-x86_64/bin
RUN cp -r /opt/subread-1.5.2-Linux-x86_64/bin/* /usr/local/bin

### HTSLIB
WORKDIR /opt
RUN git clone https://github.com/samtools/htslib.git
WORKDIR /opt/htslib
RUN autoheader
RUN autoconf
RUN ./configure
RUN make
RUN make install
ENV PATH "$PATH:/opt/htslib/"

### SAMTOOLS Version

WORKDIR /opt
RUN git clone https://github.com/samtools/samtools.git
WORKDIR /opt/samtools
RUN autoheader
RUN autoconf -Wno-syntax
RUN ./configure    # Optional, needed for choosing optional functionality
RUN make
RUN make install
ENV PATH "$PATH:/opt/samtools/"

WORKDIR /opt
RUN git clone https://github.com/lh3/bwa.git
WORKDIR /opt/bwa
RUN make
ENV PATH "$PATH:/opt/bwa/"

WORKDIR /opt/
RUN wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.7.1+-x64-linux.tar.gz
RUN tar xvzf ncbi-blast-2.7.1+-x64-linux.tar.gz
WORKDIR /opt/ncbi-blast-2.7.1+
ENV PATH "$PATH:/opt/ncbi-blast-2.7.1+/"

WORKDIR /opt/
RUN wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
RUN tar xvzf sratoolkit.current-ubuntu64.tar.gz
WORKDIR /opt/sratoolkit.2.9.0-ubuntu64
ENV PATH "$PATH: /opt/sratoolkit.2.9.0-ubuntu64/bin/"
RUN apt-get install -y unzip

WORKDIR /opt
#RUN wget https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh
#RUN bash /opt/Anaconda3-5.2.0-Linux-x86_64.sh

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda2-5.2.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

### end Conda

RUN conda install -n myenv FASTQC
RUN conda install -n myenv SCYTHE
RUN conda install -n myenv TIMMOMATIC
RUN conda install -n myenv TRIM_GALORE
RUN conda install -n myenv CUTADAPT
RUN conda install -n myenv BWA
RUN conda install -n myenv MINIMAP2
RUN conda install -n myenv BOWTIE2


RUN conda install -n myenv BEDTOOLS
RUN conda install -n myenv BEDOPS
RUN conda install -n myenv GATK
RUN conda install -n myenv FREEBAYES
RUN conda install -n myenv SAMTOOLS
RUN conda install -n myenv P
