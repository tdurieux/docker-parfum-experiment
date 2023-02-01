FROM ubuntu:18.04

# also install python version 2 used by bowtie2
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y python-pip python-dev python3 python3-dev python3-pip apt-transport-https openjdk-8-jre wget zip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir boto3 cloudpickle awscli

RUN pip3 install --no-cache-dir anadama2

RUN pip install --no-cache-dir numpy scipy pandas biopython==1.69
RUN pip install --no-cache-dir ppanini==0.7.3.1
