FROM ubuntu:latest
MAINTAINER Daryl Herzmann <akrherz@iastate.edu>

RUN apt-get update -y
RUN apt-get install --no-install-recommends libc6-dev build-essential gfortran git gcc "g++" libtool bc libx11-dev libxt-dev libxext-dev libxft-dev libxtst-dev flex byacc libmotif-dev libxml2-dev libxslt-dev libz-dev autoconf -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends wget python-pip python-dev build-essential -y && rm -rf /var/lib/apt/lists/*;

