FROM ubuntu:18.04

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y python python-dev python3 python3-dev python3-pip apt-transport-https openjdk-8-jre wget zip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir boto3 cloudpickle awscli

RUN pip3 install --no-cache-dir anadama2

# install dependencies
RUN wget https://github.com/hyattpd/Prodigal/releases/download/v2.6.3/prodigal.linux && \
    chmod +x prodigal.linux && \
    mv prodigal.linux /usr/local/bin/

RUN apt-get install --no-install-recommends -y bowtie2 ncbi-blast+ && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir numpy
RUN pip3 install --no-cache-dir waafle==0.1.0

