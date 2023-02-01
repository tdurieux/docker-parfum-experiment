FROM debian:testing
MAINTAINER ap13@sanger.ac.uk

RUN apt-get update -qq && apt-get install -y kmc git python3 python3-setuptools python3-biopython python3-pip python3-dendropy

RUN pip3 install git+git://github.com/sanger-pathogens/saffrontree.git

WORKDIR /data