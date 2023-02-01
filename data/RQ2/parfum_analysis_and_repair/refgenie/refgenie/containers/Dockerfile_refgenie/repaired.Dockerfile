# Dockerfile for refgenie environment:
# public image at nsheff/refgenie

FROM ubuntu:18.04

MAINTAINER Nathan Sheffield <nathan@code.databio.org>

# Updates and dependencies
RUN apt-get update && apt-get install --no-install-recommends -y wget git unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# htslib 1.9 (tabix cmd)
RUN apt-get install --no-install-recommends -y libz-dev libncurses-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libbz2-dev liblzma-dev && rm -rf /var/lib/apt/lists/*;
RUN wget -O ~/htslib.tar.gz https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2 && tar xjf ~/htslib.tar.gz && cd htslib-1.9 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && rm ~/htslib.tar.gz
ENV PATH="/htslib-1.9:${PATH}"

# install samtools 1.3.1
RUN wget -O ~/samtools.bz2 https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2
RUN tar -xf ~/samtools.bz2
RUN cd /samtools-1.3.1 && make
ENV PATH="/samtools-1.3.1:${PATH}"

# bowtie2 2.3.0 and deps
RUN apt-get install --no-install-recommends -y libtbb-dev && rm -rf /var/lib/apt/lists/*; # bowtie2 dependencies
RUN wget -O ~/bowtie.zip "https://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.3.0/bowtie2-2.3.0-linux-x86_64.zip?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fbowtie-bio%2Ffiles%2Fbowtie2%2F2.3.0%2F&ts=1485465820&use_mirror=kent"
RUN unzip ~/bowtie.zip
ENV PATH="/bowtie2-2.3.0:${PATH}"

# Bismark Methylation caller 0.17.0
RUN wget -O ~/bismark.zip https://github.com/FelixKrueger/Bismark/archive/0.17.0.zip
RUN unzip ~/bismark.zip
ENV PATH="/Bismark-0.17.0:${PATH}"

# hisat2 2.0.5
RUN wget -O ~/hisat.zip ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.0.5-source.zip
RUN unzip ~/hisat.zip
RUN cd hisat2-2.0.5 && make
ENV PATH="/hisat2-2.0.5:${PATH}"

# kallisto
RUN wget -O ~/kallisto.tar.gz https://github.com/pachterlab/kallisto/releases/download/v0.43.0/kallisto_linux-v0.43.0.tar.gz
RUN tar -xf ~/kallisto.tar.gz && rm ~/kallisto.tar.gz
ENV PATH="/kallisto_linux-v0.43.0:${PATH}"

# epilog meth calling
# TODO: Use public version after publication.
#RUN wget -O epilog_indexer.py https://github.com/databio/epilog/blob/master/epilog/epilog_indexer.py
ADD includes/epilog_indexer.py bin/epilog_indexer.py
RUN pip install --no-cache-dir --user regex

# UCSC twoBitToFa
ADD includes/twoBitToFa bin/twoBitToFa
RUN apt-get install --no-install-recommends -y libpng-dev && rm -rf /var/lib/apt/lists/*;

# bwa 0.7.17
RUN wget -O ~/bwa-0.7.17.tar.bz2 https://github.com/lh3/bwa/releases/download/v0.7.17/bwa-0.7.17.tar.bz2
RUN tar -xf ~/bwa-0.7.17.tar.bz2 && rm ~/bwa-0.7.17.tar.bz2
RUN cd /bwa-0.7.17 && make
ENV PATH="/bwa-0.7.17:${PATH}"

# STAR 2.7.1a
RUN wget -O ~/STAR.tar.gz https://github.com/alexdobin/STAR/archive/2.7.1a.tar.gz && tar -xf ~/STAR.tar.gz && cd STAR-2.7.1a/source && make STAR && rm ~/STAR.tar.gz
ENV PATH="/STAR-2.7.1a/source:${PATH}"

# GenomeTools 1.5.10
RUN apt-get install --no-install-recommends -y genometools && rm -rf /var/lib/apt/lists/*;
