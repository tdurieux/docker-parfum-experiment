FROM      	ubuntu:trusty
MAINTAINER 	Dominik Richter "dominik.richter@gmail.com"

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update && apt-get -y --no-install-recommends install puppet && rm -rf /var/lib/apt/lists/*; # install puppet


# add this folder
ADD . /hardening

# run puppet
RUN sh -c 'puppet apply -v -d --detailed-exitcodes --modulepath=/hardening/modules /hardening/manifests/docker.pp; exit 0'

# simple command to get into the box
CMD /bin/bash

