FROM centos:7.3.1611
MAINTAINER Tim Massingham <tim.massingham@nanoporetech.com>
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y gcc git make cmake && rm -rf /var/cache/yum

RUN yum install -y gcc CUnit CUnit-devel hdf5 hdf5-devel openblas openblas-devel && rm -rf /var/cache/yum
# For cblas.h
RUN yum install -y atlas-devel && rm -rf /var/cache/yum
RUN ln -s /usr/lib64/libopenblaso.so /usr/lib64/libblas.so

RUN git clone --depth 1 http://github.com/nanoporetech/scrappie.git

RUN cd scrappie && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make test

