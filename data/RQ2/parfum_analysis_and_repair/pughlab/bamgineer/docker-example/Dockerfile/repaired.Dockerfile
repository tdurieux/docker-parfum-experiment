FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
            wget \
            bzip2 \
            gcc \
            g++ \
            make \
            zlib1g-dev \
            libncurses5-dev \
            git \
            python \
            python-pip \
            vim \
            openjdk-8-jre && rm -rf /var/lib/apt/lists/*;

# PGP bams and VCF
#RUN wget https://my.pgp-hms.org/user_file/download/2312 && \
#  mv 2312 chr21.bam
#RUN wget https://my.pgp-hms.org/user_file/download/2291 && \
#  mv 2291 pgp.vcf

# samtools/1.2
RUN wget https://github.com/samtools/samtools/releases/download/1.2/samtools-1.2.tar.bz2 && \
  tar xjf samtools-1.2.tar.bz2 && \
  cd samtools-1.2 && make && rm samtools-1.2.tar.bz2
ENV PATH=$PATH:/samtools-1.2

# bedtools/2.26.0
RUN apt-get install -y --no-install-recommends bedtools && rm -rf /var/lib/apt/lists/*;

# vcftools/0.1.15
RUN apt-get install --no-install-recommends -y vcftools && rm -rf /var/lib/apt/lists/*;

# bamUtil/1.0.14
RUN wget https://github.com/statgen/bamUtil/archive/master.tar.gz && \
  tar -xzf master.tar.gz && \
  cd bamUtil-master && \
  make cloneLib && \
  make && \
  make install INSTALLDIR=/bamUtil-install && rm master.tar.gz

# sambamba/0.5.4
RUN wget https://github.com/biod/sambamba/releases/download/v0.5.4/sambamba_v0.5.4_linux.tar.bz2 && \
  tar xjf sambamba_v0.5.4_linux.tar.bz2 && rm sambamba_v0.5.4_linux.tar.bz2
RUN chmod 777 sambamba_v0.5.4

# beagle
RUN wget https://faculty.washington.edu/browning/beagle/beagle.09Nov15.d2a.jar

# python packages
RUN pip install --no-cache-dir pysam==0.8.4
RUN pip install --no-cache-dir pybedtools
RUN pip install --no-cache-dir PyVCF==0.6.7
RUN pip install --no-cache-dir pathos
RUN pip install --no-cache-dir pandas

# bamgineer
RUN git clone https://github.com/pughlab/bamgineer.git

ENTRYPOINT ["python","/bamgineer/src/simulate.py"]
