FROM ubuntu:18.04

# also install python version 2 used by bowtie2
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y python python-dev python3 python3-dev python3-pip apt-transport-https openjdk-8-jre wget zip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir boto3 cloudpickle awscli

RUN pip3 install --no-cache-dir anadama2

# install kneaddata and dependencies
RUN pip3 install --no-cache-dir humann==3.0.0.alpha.4 --no-binary :all:
RUN pip3 install --no-cache-dir numpy cython
RUN pip3 install --no-cache-dir biom-format
RUN pip3 install --no-cache-dir metaphlan

WORKDIR /tmp
