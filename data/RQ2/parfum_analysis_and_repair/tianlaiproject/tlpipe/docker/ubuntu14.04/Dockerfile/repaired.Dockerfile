# install the tlpipe

FROM ubuntu:14.04
MAINTAINER Shifan Zuo "sfzuo@bao.ac.cn"
ENV REFRESHED_AT 2017-08-02

# update package info
RUN apt-get -yqq update

# install prerequisites for Python
RUN apt-get -yqq --no-install-recommends install python-dev && rm -rf /var/lib/apt/lists/*;

# install python-pip
RUN apt-get -yqq --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;

# upgrade pip to the latest version
RUN pip install --no-cache-dir -U pip

# install numpy, scipy, matplotlib
RUN pip install --no-cache-dir numpy scipy matplotlib
# RUN apt-get -yqq install python-numpy python-scipy python-matplotlib

# install MPI environment, either mpich or openmpi
# install mpich
RUN apt-get -yqq --no-install-recommends install mpich && rm -rf /var/lib/apt/lists/*;

# install openmpi
# RUN apt-get -yqq install openmpi-bin libopenmpi-dev

# install mpi4py
RUN pip install --no-cache-dir mpi4py

# install HDF5
RUN apt-get -yqq --no-install-recommends install libhdf5-dev && rm -rf /var/lib/apt/lists/*;

# install h5py
RUN pip install --no-cache-dir h5py

# install pyephem
RUN pip install --no-cache-dir pyephem

# install healpy
RUN pip install --no-cache-dir healpy

# install cython
RUN pip install --no-cache-dir cython

# install git
RUN apt-get -yqq --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

# install cora
# RUN pip install git+https://github.com/zuoshifan/cora.git
RUN pip install --no-cache-dir git+https://github.com/radiocosmology/cora.git

# install aipy
RUN pip install --no-cache-dir git+https://github.com/zuoshifan/aipy.git@zuo/develop

# install caput
RUN pip install --no-cache-dir git+https://github.com/zuoshifan/caput.git@zuo/develop

# install tlpipe
# RUN pip install git+https://github.com/TianlaiProject/tlpipe.git@zuo/develop
WORKDIR /usr/src
RUN git clone https://github.com/TianlaiProject/tlpipe.git
WORKDIR /usr/src/tlpipe
# RUN git checkout zuo/develop
Run python setup.py develop

# clean downloaded packages
WORKDIR /
RUN apt-get autoremove
