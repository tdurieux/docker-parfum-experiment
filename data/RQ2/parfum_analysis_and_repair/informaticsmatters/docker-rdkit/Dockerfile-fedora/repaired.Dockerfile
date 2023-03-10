FROM fedora:28

RUN dnf -y update && dnf -y upgrade && dnf -y install\
 gcc-c++\
 python3-devel\
 boost-devel\
 eigen3-devel\
 cmake\
 tk-devel\
 readline-devel\
 zlib-devel\
 bzip2-devel\
 sqlite-devel\
 @development-tools\
 swig\
 git\
 zip\
 wget

ENV RDKIT_BRANCH=master
RUN git clone -b $RDKIT_BRANCH --single-branch https://github.com/rdkit/rdkit.git

ENV RDBASE=/rdkit
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$RDBASE/lib:/usr/lib64
ENV PYTHONPATH=$PYTHONPATH:$RDBASE

RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build

RUN cmake .. &&\
 make &&\
 make install &&\
 make clean