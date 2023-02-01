from continuumio/anaconda3:latest
RUN apt-get -y update && apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;

# install essential packages for pysam
RUN apt-get -y --no-install-recommends install zlib1g-dev && apt-get -y --no-install-recommends install libbz2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libcurl4-gnutls-dev && apt-get -y --no-install-recommends install libssl-dev && rm -rf /var/lib/apt/lists/*;

# install methylpy, bowtie/bowtie2 and other methylpy dependencies
RUN pip install --no-cache-dir methylpy
RUN conda install -y -c bioconda bowtie && conda install -y -c bioconda bowtie2
RUN pip install --no-cache-dir cutadapt && conda install -y -c bioconda samtools
RUN mkdir -p /usr/share/man/man1
RUN apt-get -y --no-install-recommends install openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;


# install dependencies for DMRfind
RUN apt-get -y --no-install-recommends install libgsl-dev && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/lib/x86_64-linux-gnu/libgsl.so.23 lib/libgsl.so.0
