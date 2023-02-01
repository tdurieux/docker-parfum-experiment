#FROM ubuntu:latest
#FROM ubuntu:20.04
#MAINTAINER Ewelina Rupnik <ewelina.rupnik@ign.fr>

# CUDA refer to https://gitlab.com/nvidia/container-images/cuda/blob/master/doc/supported-tags.md
FROM nvidia/cuda:11.4.0-runtime-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive

# Set the working directory
ENV foo /etc/opt/
WORKDIR ${foo}  

#MicMac dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
						build-essential \
						make \
                    cmake \
                    git \
						python3-pip \
                    proj-bin \
						exiv2 \
                    exiftool \
                    imagemagick \
						libboost-all-dev \
						xorg \
                 openbox \
                    qt5-default \
                    meshlab \
                    vim \
						wget && rm -rf /var/lib/apt/lists/*;



#MicMac clone
RUN git clone https://github.com/micmacIGN/micmac.git

ADD ./ ${foo}/micmac

#MicMac build & compile
WORKDIR micmac
RUN mkdir build
WORKDIR build
RUN cmake ../ && make install -j8

#build PSMNet
WORKDIR ${foo}
RUN cd micmac/MMVII/bin && \
    make && \
    cd .. && \ 
    cd src/DenseMatch && \
    /bin/bash install.sh

#MicMac add environmental variable to executables
ENV PATH=${foo}micmac/bin:${foo}micmac/MMVII/bin:${PATH}
RUN echo ${foo}micmac/bin:${foo}micmac/MMVII/bin:${PATH}
