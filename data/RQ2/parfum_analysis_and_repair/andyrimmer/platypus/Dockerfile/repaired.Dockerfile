FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -y build-essential \
			python-dev \
			python-pip \
			git \
			wget \
			autoconf \
			zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# Make a working directory
RUN mkdir /code

ADD . /code/Platypus

# Install htslib
RUN wget https://github.com/samtools/htslib/releases/download/1.3/htslib-1.3.tar.bz2
RUN tar xjf htslib-1.3.tar.bz2 && rm htslib-1.3.tar.bz2
RUN cd htslib-1.3 && autoconf && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

# Install Cython
RUN pip install --no-cache-dir cython

ENV C_INCLUDE_PATH /usr/local/include
ENV LIBRARY_PATH /usr/local/lib
ENV LD_LIBRARY_PATH /usr/local/lib

# Compile
RUN cd /code/Platypus && make
