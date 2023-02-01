# HiFive latest version docker container build file

# Load base container ubuntu version 14.04

FROM ubuntu:14.04

# Load python2.7, samtools, and gfortran

RUN apt-get update
RUN apt-get install --no-install-recommends -y python2.7-dev samtools gfortran && rm -rf /var/lib/apt/lists/*;

# Load libraries hdf5, atlas,

RUN apt-get install --no-install-recommends -y libhdf5-dev libatlas-base-dev && rm -rf /var/lib/apt/lists/*;

# Load mpi and supporting library

# RUN apt-get install openmpi-bin openmpi-common openssh-client openssh-server libopenmpi1.6 libopenmpi-dev -y

# Get pip

RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -U setuptools

# Get python packages: numpy, scipy, pysam, cython, mpi4py, and h5py

# RUN pip install numpy scipy pysam cython mpi4py
RUN pip install --no-cache-dir numpy scipy pysam cython
RUN pip install --no-cache-dir h5py

# Get python package PIL

RUN ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so.8.0.2 /usr/lib/libjpeg.so
RUN ln -s /usr/lib/x86_64-linux-gnu/libz.so /usr/lib/libz.so
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN cd tmp && wget https://effbot.org/downloads/Imaging-1.1.7.tar.gz && tar xzf Imaging-1.1.7.tar.gz && cd Imaging-1.1.7 && python setup.py install && rm Imaging-1.1.7.tar.gz

# Get hifive

RUN apt-get install --no-install-recommends -y unzip wget && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p tmp && cd tmp && wget https://github.com/bxlab/hifive/archive/v1.1.3.zip && unzip v1.1.3.zip && cd hifive-1.1.3 && python setup.py install

# Get hifive test data

RUN mkdir -p test_data && cd test_data && wget https://files.figshare.com/2259932/test5Cdata.tar.bz2 && tar xjf test5Cdata.tar.bz2 && rm test5Cdata.tar.bz2
RUN cd test_data && wget https://files.figshare.com/2259931/testHiCdata.tar.bz2 && tar xjf testHiCdata.tar.bz2 && rm testHiCdata.tar.bz2

MAINTAINER Michael Sauria <mike.sauria@jhu.edu>
