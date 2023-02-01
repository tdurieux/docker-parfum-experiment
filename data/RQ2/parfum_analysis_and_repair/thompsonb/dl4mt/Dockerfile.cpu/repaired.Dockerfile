FROM ubuntu:16.04
MAINTAINER Tom Kocmi <kocmi@ufal.mff.cuni.cz>

RUN apt-get update && apt-get install --no-install-recommends -y \
	cmake \
	git \
	python \
	python3 \
	vim \
	nano \
	python-dev \
	python-pip \
	python-pygraphviz \
	xml-twig-tools && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir numpy numexpr cython theano ipdb

RUN mkdir -p /path/to
WORKDIR /path/to/

# Install mosesdecoder
RUN git clone https://github.com/moses-smt/mosesdecoder

# Install subwords
RUN git clone https://github.com/rsennrich/subword-nmt

# Install nematus
COPY . /path/to/nematus
WORKDIR /path/to/nematus
RUN python setup.py install

WORKDIR /

# playground will contain user defined scripts, it should be run as:
# docker run -v `pwd`:/playground -it nematus-docker
RUN mkdir playground
WORKDIR /playground

