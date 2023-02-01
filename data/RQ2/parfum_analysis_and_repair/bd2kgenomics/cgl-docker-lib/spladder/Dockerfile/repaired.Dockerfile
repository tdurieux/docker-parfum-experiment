# Set the base image to Ubuntu
FROM ubuntu:14.04

# File Author / Maintainer
MAINTAINER John Vivian <jtvivian@gmail.com>

# Update the repository sources list
RUN apt-get update && apt-get install --no-install-recommends --yes \
        build-essential \
        git \
        python-pip \
        python-dev \
        zlib1g-dev \
        python-scipy \
        libhdf5-serial-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir cython pysam h5py

# Download Spladder
RUN mkdir /data
RUN git clone https://github.com/ratschlab/spladder /opt/spladder

# CGL Boilerplate
COPY wrapper.sh /opt/spladder/
WORKDIR /data

ENTRYPOINT ["sh", "/opt/spladder/wrapper.sh"]
