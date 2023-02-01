FROM ubuntu:18.04

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y python python-dev python3 python3-dev python3-pip apt-transport-https openjdk-8-jre wget zip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir boto3 cloudpickle awscli

RUN pip3 install --no-cache-dir anadama2

# install dependencies
RUN apt-get install --no-install-recommends -y muscle cd-hit ncbi-blast+ && rm -rf /var/lib/apt/lists/*;

# install usearch
RUN wget https://drive5.com/downloads/usearch9.0.2132_i86linux32.gz && \
    gunzip usearch9.0.2132_i86linux32.gz && \
    chmod +x usearch9.0.2132_i86linux32 && \
     mv usearch9.0.2132_i86linux32 /usr/local/bin/usearch

RUN pip3 install --no-cache-dir shortbred==0.9.5

