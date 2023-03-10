################################################################################
# Base image
################################################################################
FROM compbio/ngseasy-base:1.0-r001

################################################################################
# Maintainer
################################################################################
MAINTAINER Stephen Newhouse stephen.j.newhouse@gmail.com

################################################################################
# Set correct environment variables.
################################################################################
##ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

################################################################################
# general purpose tools
################################################################################
RUN apt-get update -y && apt-get upgrade -y

# python and stuff
RUN apt-get install --no-install-recommends -y \
                        isomd5sum \
                        python-numpy python-scipy python-pysam python-pyisomd5sum && rm -rf /var/lib/apt/lists/*;

# cython
RUN cd /tmp && \
    wget https://cython.org/release/Cython-0.22.tar.gz && \
    chmod 777 Cython-0.22.tar.gz && \
    tar xvf Cython-0.22.tar.gz && \
    chmod -R 777 Cython-0.22 && \
    cd Cython-0.22 && \
    python setup.py install && rm Cython-0.22.tar.gz

################################################################################
# install dependencies
################################################################################
RUN apt-get install --no-install-recommends -y libX11-dev libXpm-dev libXft-dev libXext-dev && rm -rf /var/lib/apt/lists/*;

################################################################################
# get ROOT
################################################################################
RUN cd /tmp && \
    curl -f -OL ftp://root.cern.ch/root/root_v5.34.20.source.tar.gz && \
    tar -xvf root_v5.34.20.source.tar.gz && \
    cd root && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make -j `ncpu` && \
    cd .. && \
    mv root /usr/local && rm root_v5.34.20.source.tar.gz

RUN  echo "source /usr/local/root/bin/thisroot.sh" >>  /root/.bashrc  && \
    /bin/bash -c ". /root/.bashrc && source /root/.bashrc"

################################################################################
# speedseq
################################################################################
ENV ROOTSYS /usr/local/root

RUN cd /usr/local/pipeline && \
    git clone --recursive https://github.com/cc2qe/speedseq && \
    chmod -R 777 /usr/local/pipeline/speedseq && \
    cd /usr/local/pipeline/speedseq && \
    make -j `ncpu` ROOTFLAGS=" -pthread -m64" && \
    chmod -R 777 /usr/local/pipeline/speedseq

RUN echo "export PATH=/usr/local/pipeline/speedseq/bin:\$PATH" >> ~/.bashrc && \
    /bin/bash -c "source ~/.bashrc"

ADD speedseq_b37.config  /usr/local/pipeline/speedseq/bin/
ADD speedseq_hg19.config /usr/local/pipeline/speedseq/bin/

################################################################################
# PERMISSIONS
################################################################################
RUN chmod -R 777 /usr/local/pipeline
RUN chown -R pipeman:ngsgroup /usr/local/pipeline

################################################################################
#Cleanup the temp dir
################################################################################
RUN rm -rf /tmp/*

################################################################################
#open ports private only
################################################################################
EXPOSE 8080

################################################################################
# Use baseimage-docker's bash.
################################################################################
CMD ["/bin/bash"]

################################################################################
#Clean up APT when done.
################################################################################
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get autoclean && apt-get autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/
