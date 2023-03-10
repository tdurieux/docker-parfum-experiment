# Copyright IRT-Systemx 2018

FROM centos:7.6.1810

MAINTAINER Alter Ego Engineering <luca.dallolio@aego.ai>

#RUN yum install -y epel-release && yum install -y cmake3
# xterm tk boost-python-devel ca-certificates
RUN yum install -y libunwind curl gcc automake make gcc-c++ gcc-gfortran gettext python3-devel zlib-devel bison flex swig lapack-devel vim bash python36-numpy.x86_64 && rm -rf /var/cache/yum

#RUN curl -SL http://download.savannah.nongnu.org/releases/libunwind/libunwind-1.4.0.tar.gz | tar -xzC /root
#ENV LIBUNWIND_INSTALL=/opt/libunwind
#WORKDIR /root/libunwind-1.4.0
#RUN ./configure --prefix=$LIBUNWIND_INSTALL && make -j && make install

#RUN yum update -y && yum install -y python-pip
#RUN pip install numpy==1.9

RUN curl -f -SLk https://cmake.org/files/v3.11/cmake-3.11.4.tar.gz | tar -xzC /root
WORKDIR /root/cmake-3.11.4
RUN ./bootstrap --prefix=/usr/local && make -j && make install && cmake --version

# yum install -y scl-utils && scl enable Boost169
RUN yum install -y yum-plugin-copr && yum copr enable -y denisarnaud/boost1.69 && yum install -y boost1.69 && rm -rf /var/cache/yum

#RUN curl -SLk https://phoenixnap.dl.sourceforge.net/project/boost/boost/1.58.0/boost_1_58_0.tar.gz | tar -xzC /root
#WORKDIR /root/boost_1_58_0
#RUN curl -SLk https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.gz | tar -xzC /root
#WORKDIR /root/boost_1_67_0
#RUN yum install -y python-devel
#RUN ./bootstrap.sh --with-python-version=3.6 && ./b2 install --with=all

RUN curl -f -SLk https://www.code-aster.org/FICHIERS/aster-full-src-14.4.0-1.noarch.tar.gz | tar -xzC /root
ENV ASTER_BUILD=/root/aster-full-src-14.4.0
ENV ASTER_INSTALL=/opt/aster
WORKDIR $ASTER_BUILD
#RUN ln -s /bin/cmake3 /usr/local/bin/cmake
RUN yum install -y less tmux && rm -rf /var/cache/yum
RUN LC_ALL=C TERMINAL=/usr/bin/tmux python3 setup.py install --prefix=$ASTER_INSTALL --noprompt && rm -Rf /opt/aster/14.4/share/aster/tests
ENV MFRONT_INSTALL=$ASTER_INSTALL/mfront-3.2.1
ENV MFRONT=$MFRONT_INSTALL/bin/mfront
ENV TFEL_CONFIG=$MFRONT_INSTALL/bin/tfel-config
ENV PATH=$PATH:$MFRONT_INSTALL/bin

RUN echo "vers : STABLE:/opt/aster/14.4/share/aster" >> $ASTER_INSTALL/etc/codeaster/aster

RUN curl -f -SLk https://github.com/ldallolio/NASTRAN-95/archive/v0.1.95.tar.gz | tar -xzC /root
ENV NASTRAN_BUILD=/root/NASTRAN-95-0.1.95
ENV NASTRAN_INSTALL=/opt/nastran
WORKDIR $NASTRAN_BUILD
RUN ./bootstrap && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$NASTRAN_INSTALL && make && make install
RUN mv $NASTRAN_INSTALL/bin/nastran $NASTRAN_INSTALL/bin/nast-run && cp -R ./rf  $NASTRAN_INSTALL/share
COPY ./dockerdata/nastran $NASTRAN_INSTALL/bin

FROM centos:7.6.1810

WORKDIR /opt/aster
COPY --from=0 /opt/aster .
WORKDIR /opt/nastran
COPY --from=0 /opt/nastran .
WORKDIR /usr/local
COPY --from=0 /usr/local .

RUN yum install -y epel-release && yum install -y python3 gcc-c++ git sudo make zlib lapack blas vim boost-devel libgfortran bash python36-numpy.x86_64 cmake3 doxygen && rm -rf /var/cache/yum

ENV ASTER_INSTALL=/opt/aster
ENV NASTRAN_INSTALL=/opt/nastran
ENV MED_INSTALL=$ASTER_INSTALL/public/med-4.0.0
ENV HDF_INSTALL=$ASTER_INSTALL/public/hdf5-1.10.3
ENV CXXFLAGS="-isystem $MED_INSTALL/include -isystem $HDF_INSTALL/include"
RUN sudo ln -s $ASTER_INSTALL/bin/as_run /usr/local/bin
ENV HDF5_ROOT=$HDF_INSTALL

RUN groupadd -g 1777 vega && adduser -s /bin/bash -u 1777 -g vega vega && echo "vega ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && echo 'export PATH=$ASTER_INSTALL/bin:$NASTRAN_INSTALL/bin:$PATH' >> /home/vega/.bashrc
USER vega
WORKDIR /home/vega
