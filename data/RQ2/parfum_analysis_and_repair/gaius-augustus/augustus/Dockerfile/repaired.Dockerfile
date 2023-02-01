FROM ubuntu:20.04

# Set timezone in tzdata
ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin"

# Install required packages
RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential wget git autoconf && rm -rf /var/lib/apt/lists/*;

# Install dependencies for AUGUSTUS comparative gene prediction mode (CGP)
RUN apt-get install --no-install-recommends -y libgsl-dev libboost-all-dev libsuitesparse-dev liblpsolve55-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsqlite3-dev libmysql++-dev && rm -rf /var/lib/apt/lists/*;

# Install dependencies for the optional support of gzip compressed input files
RUN apt-get install --no-install-recommends -y libboost-iostreams-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# Install dependencies for bam2hints and filterBam
RUN apt-get install --no-install-recommends -y libbamtools-dev && rm -rf /var/lib/apt/lists/*;

# Install additional dependencies for bam2wig
RUN apt-get install --no-install-recommends -y samtools libhts-dev && rm -rf /var/lib/apt/lists/*;

# Install additional dependencies for homGeneMapping and utrrnaseq
RUN apt-get install --no-install-recommends -y libboost-all-dev && rm -rf /var/lib/apt/lists/*;

# Install additional dependencies for scripts
RUN apt-get install --no-install-recommends -y cdbfasta diamond-aligner libfile-which-perl libparallel-forkmanager-perl libyaml-perl libdbd-mysql-perl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends python3-biopython && rm -rf /var/lib/apt/lists/*;

# Install hal - required by homGeneMapping
# execute the commented out code if you want to use this program - see auxprogs/homGeneMapping/Dockerfile
#RUN apt-get install -y libhdf5-dev
#RUN git clone https://github.com/benedictpaten/sonLib.git /opt/sonLib
#WORKDIR /opt/sonLib
#RUN make
#RUN git clone https://github.com/ComparativeGenomicsToolkit/hal.git /opt/hal
#WORKDIR /opt/hal
#ENV RANLIB=ranlib
#RUN make
#ENV PATH="${PATH}:/opt/hal/bin"

# Clone AUGUSTUS repository
ADD / /root/augustus

# Build AUGUSTUS
WORKDIR "/root/augustus"
RUN make clean
RUN make
RUN make install
ENV PATH="/root/augustus/bin:/root/augustus/scripts:${PATH}"

# Test AUGUSTUS
RUN make unit_test
