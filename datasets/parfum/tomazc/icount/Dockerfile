FROM ubuntu:16.04
MAINTAINER Tomaz Curk <tomazc@gmail.com>

# thanks to https://github.com/bschiffthaler/ngs/blob/master/base/Dockerfile
# and https://github.com/AveraSD/ngs-docker-star/blob/master/Dockerfile

RUN useradd -m -d /home/icuser icuser

# update system
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    build-essential \
    gfortran \
    libatlas-base-dev \
    wget \
    g++ \
    make \
    binutils \
    python3 \
    python3-pip \
    python3-setuptools \
    python-virtualenv \
    python-pip \
    pandoc \
    git && \
    apt-get build-dep -y python3-matplotlib

RUN apt-get autoclean -y && \
    apt-get autoremove -y


#################
### samtools
RUN apt-get install -y \
    zlib1g-dev \
    liblzma-dev \
    libbz2-dev \
    samtools


#################
### bedtools, need at least version 2.26, where merge command reports strand
# RUN apt-get install -y bedtools
WORKDIR /tmp/bedtools
RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.27.1/bedtools-2.27.1.tar.gz
RUN tar -zxvf bedtools-2.27.1.tar.gz
WORKDIR /tmp/bedtools/bedtools2
RUN make
RUN make install
WORKDIR /tmp
RUN rm -rfv bedtools

#################
### RNA-star
WORKDIR /tmp/STAR
RUN wget https://github.com/alexdobin/STAR/archive/2.6.1a.tar.gz
RUN tar -xvzf 2.6.1a.tar.gz
WORKDIR /tmp/STAR/STAR-2.6.1a/source
RUN make STAR
RUN mkdir -p /home/icuser/bin && cp STAR /home/icuser/bin
WORKDIR /tmp
RUN rm -rfv STAR


#################
#### iCount
RUN chown -R icuser.icuser /home/icuser

USER icuser
WORKDIR /home/icuser
RUN virtualenv -p python3 /home/icuser/.icountenv

USER root
# to speed-up building of Docker images
RUN /home/icuser/.icountenv/bin/pip install numpy pandas pysam pybedtools numpydoc matplotlib

ADD . /home/icuser/iCount_src
RUN chown -R icuser.icuser /home/icuser

USER icuser
WORKDIR /home/icuser/iCount_src

RUN ../.icountenv/bin/pip install -e .[docs,test]

USER root
RUN echo "source /home/icuser/.icountenv/bin/activate" >> /etc/bash.bashrc
USER icuser

RUN mkdir /home/icuser/storage

ENV PATH /home/icuser/bin:$PATH

WORKDIR /home/icuser

CMD ["/bin/bash"]
