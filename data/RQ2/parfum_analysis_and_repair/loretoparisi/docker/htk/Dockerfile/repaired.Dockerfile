#
# numpy, scipy, theano, lasagne, pdnn, and htk
# @author Loreto Parisi (loretoparisi at gmail dot com)
# v1.0.0
#
# Copyright (c) 2017 Loreto Parisi - https://github.com/loretoparisi/docker
#
FROM ubuntu:16.04

MAINTAINER Loreto Parisi <loretoparisi@gmail.com>

# working directory
ENV HOME /root
WORKDIR $HOME

# packages list
RUN \
	apt-get update && apt-get install --no-install-recommends -y \
    libx11-dev \
    gawk \
    python-dev \
    python-pip \
    curl \
    git && rm -rf /var/lib/apt/lists/*;

# pip
RUN pip install --no-cache-dir --upgrade pip

# copy & install compat-gcc-34-c++ compat-gcc-34
#COPY lib/*.deb $HOME/
#RUN \
#    dpkg -i $HOME/compat-gcc-34-c++_3.4.6-20_amd64.deb && \
#    dpkg -i $HOME/compat-gcc-34-c++_3.4.6-20_amd64.deb

# numlib
RUN pip install --no-cache-dir numpy scipy
# theano and lasagne
RUN pip install --no-cache-dir theano
RUN pip install --no-cache-dir https://github.com/Lasagne/Lasagne/archive/master.zip# last working version of Lasagne

# utility dependencies
RUN pip install --no-cache-dir python-Levenshtein sklearn

# HTK
RUN \
    git clone https://github.com/loretoparisi/htk.git && \
    cd $HOME/htk && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-hslab && \
    make all && \
    make install

# pdnn
# @see https://www.cs.cmu.edu/~ymiao/pdnntk.html
RUN git clone https://github.com/yajiemiao/pdnn

# env
ENV PYTHONPATH $HOME/pdnn:$PYTHONPATH

CMD ["bash"]
