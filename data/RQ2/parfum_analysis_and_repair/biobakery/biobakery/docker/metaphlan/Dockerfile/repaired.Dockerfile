FROM ubuntu:18.04

# also install python version 2 used by bowtie2
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y python python-dev python3 python3-dev python3-pip apt-transport-https openjdk-8-jre wget zip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir boto3 cloudpickle awscli

RUN pip3 install --no-cache-dir anadama2

RUN apt-get install --no-install-recommends -y bowtie2 && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir numpy
RUN pip3 install --no-cache-dir cython
RUN pip3 install --no-cache-dir biom-format

# install cmseq
RUN apt-get install --no-install-recommends -y git && \
    git clone https://github.com/SegataLab/cmseq.git && \
    cd cmseq && \
    python3 setup.py install && \
    cd ../ && \
    rm -r cmseq && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir metaphlan==3.0.6
RUN metaphlan --install --nproc 24

WORKDIR /tmp
