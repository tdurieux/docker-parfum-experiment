FROM debian:testing
MAINTAINER ap13@sanger.ac.uk

RUN apt-get update -qq && apt-get install --no-install-recommends -y kmc git python3 python3-setuptools python3-biopython python3-pip python3-dendropy && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir git+git://github.com/sanger-pathogens/saffrontree.git

WORKDIR /data