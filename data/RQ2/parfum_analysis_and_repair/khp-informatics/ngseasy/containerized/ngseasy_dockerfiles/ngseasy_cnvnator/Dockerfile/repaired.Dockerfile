# Base image
FROM compbio/ngseasy-base:1.0

# Maintainer
MAINTAINER Stephen Newhouse stephen.j.newhouse@gmail.com

# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# general purpose tools
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y python python-dev python-yaml ncurses-dev python-numpy python-pip && rm -rf /var/lib/apt/lists/*;

# install dependencies
RUN apt-get install --no-install-recommends -y libX11-dev libXpm-dev libXft-dev libXext-dev && rm -rf /var/lib/apt/lists/*;

# get ROOT
RUN curl -f -OL ftp://root.cern.ch/root/root_v5.34.20.source.tar.gz && \
    tar -xvf root_v5.34.20.source.tar.gz && \
    cd root && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    cd .. && \
    sudo mv root /usr/local && rm root_v5.34.20.source.tar.gz

RUN touch /root/.bashrc  && cat "source /usr/local/root/bin/thisroot.sh" >>  /root/.bashrc  && \
    . /root/.bashrc

# speedseq   
RUN git clone --recursive https://github.com/cc2qe/speedseq && \
    cd speedseq && \
    python speedseq_setup.py && \
    cp -r bin/* /usr/local/bin/ && \ 
    make cnvnator-multi && \
    cp bin/* /usr/local/bin

## NEED TO EDIT MAKE FILE FOR CNVNATOR
## ADD ROOTFLAGS = -pthread -m64
## ADD FLAGS    = -L /lib64

#- VERSION   = v0.3
#- ROOTFLAGS = -pthread -m64
#- #########ROOTFLAGS = -m64 -O3
#- LIBS      = -lz
#- ROOTLIBS  = -L$(ROOTSYS)/lib -lCore -lCint -lRIO -lNet -lHist -lGraf -lGraf3d \
#-		-lGpad -lTree -lRint -lMatrix -lPhysics \
#-		-lMathCore -lThread -lGui
#- FLAGS    = -L /lib64 


RUN mkdir -p /root/genomes/GRCh37/chroms && \
    cd /root/genomes/GRCh37/chroms && \
    wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/technical/reference/human_g1k_v37.fasta.gz && \
    wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/technical/reference/human_g1k_v37.fasta.fai && \
    gunzip ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/technical/reference/human_g1k_v37.fasta.gz && \
    cat human_g1k_v37.fasta | awk 'BEGIN { CHROM="" } { if ($1~"^>") CHROM=substr($1,2); print $0 > CHROM".fa" }'

#-------------------------------PERMISSIONS--------------------------
RUN chmod -R 777 /usr/local/pipeline
RUN chown -R pipeman:ngsgroup /usr/local/pipeline

#---------------------------------------------------------------------
#Cleanup the temp dir
RUN rm -rf /tmp/*

#open ports private only
EXPOSE 8080

# Use baseimage-docker's bash.
CMD ["/bin/bash"]

#Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get autoclean && apt-get autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/