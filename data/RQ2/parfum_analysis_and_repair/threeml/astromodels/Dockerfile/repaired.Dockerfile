FROM ubuntu:16.04

MAINTAINER Giacomo Vianello <giacomov@stanford.edu>

# Override the default shell (sh) with bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Update repositories and install needed packages
# I use one long line so that I can remove all .deb files at the end
# before Docker writes out this layer

RUN apt-get update && apt-get install --no-install-recommends -y python2.7 python2.7-dev python-dev wget python-pip git python-tk libreadline6-dev libncurses5-dev xorg-dev gcc g++ gfortran perl-modules && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /heasoft/src

COPY heasoft-6.19src.tar.gz /heasoft/src

RUN cd /heasoft && mkdir build && cd src && tar zxvf heasoft-6.19src.tar.gz && cd heasoft-6.19/BUILD_DIR/ && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/heasoft/build && make && make install && rm -rf /heasoft/src && rm heasoft-6.19src.tar.gz

RUN pip install --no-cache-dir virtualenv

RUN apt-get install -y --no-install-recommends sudo && rm -rf /var/lib/apt/lists/*;

WORKDIR /
