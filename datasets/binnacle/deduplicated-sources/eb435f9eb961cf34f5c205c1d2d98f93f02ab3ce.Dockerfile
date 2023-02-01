# © Copyright IBM Corporation 2017, 2019.
# LICENSE: Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0)  

####################### Dockerfile for Protobuf version 3.7.1 ##############
#
# Protocol Buffers is a method of serializing structured data.
#
# To build this image, from the directory containing this Dockerfile
# (assuming that the file is named Dockerfile):
# docker build -t <image_name> .
#
# To simply run the resultant image, and provide a bash shell:
# docker run -it <image_name> /bin/bash
#
# Below is the command to use protobuf:
# docker run --rm --name <container name> -it <protobuf_image> protoc <argument>
#
# Below is an example to display protobuf help options:
# docker run --rm --name <container name> -it <protobuf_image> protoc --help
#
#############################################################################

# Base image
FROM s390x/ubuntu:16.04

# The author
MAINTAINER LoZ Open Source Ecosystem (https://www.ibm.com/developerworks/community/groups/community/lozopensource)

ENV SOURCE_DIR=/tmp/source
WORKDIR $SOURCE_DIR

# Installing dependencies
RUN apt-get update && apt-get install -y \
	autoconf \
	automake \
	bzip2 \
	curl \
	g++ \
	git \
    libtool \
    make \
    tar \
    unzip \
    wget \
	
# Download and install protobuf
 && git clone git://github.com/google/protobuf.git \
 && cd protobuf \
 && git checkout v3.7.1 \
 && git config --global url."git://github.com/".insteadOf "https://github.com/" \
 && git submodule update --init --recursive \
 
# Build
 && ./autogen.sh \
 && ./configure \
 && make && make install && ldconfig \
 && rm -rf $SOURCE_DIR \
# Tidy and clean up
 && apt-get remove -y \
	autoconf \
	automake \
	bzip2 \
	curl \
	g++ \
	git \
    libtool \
    make \
    unzip \
    wget \
 && apt-get autoremove -y && apt autoremove -y \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH=/usr/local/lib

CMD ["protoc","--version"]
