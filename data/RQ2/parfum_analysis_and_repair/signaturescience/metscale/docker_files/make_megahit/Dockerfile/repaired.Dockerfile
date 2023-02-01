FROM ubuntu:16.04

#Define dependencies
ENV PACKAGES g++ make git zlib1g-dev python

# Set the maintaniner
MAINTAINER ptbrooks@ucdavis.edu

#Update and install packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y ${PACKAGES} && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /home

#Install MEGAHIT
RUN git clone https://github.com/voutcn/megahit.git /home/megahit
RUN cd /home/megahit && make
