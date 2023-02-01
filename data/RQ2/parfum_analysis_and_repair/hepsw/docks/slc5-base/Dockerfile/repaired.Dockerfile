FROM ubuntu
MAINTAINER Sebastien Binet "binet@cern.ch"

# install a few dependencies
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
	git rinse sudo tar && rm -rf /var/lib/apt/lists/*;

RUN git clone \
	git://github.com/hepsw/docks \
	/docks

RUN mkdir /build && \
	cd /build && \
	/docks/mkimage-slc.sh hepsw/slc5-base slc-5
