FROM ubuntu:18.04

USER root

RUN apt-get update && apt-get install --no-install-recommends -y vim curl liblapack-dev libblas-dev zlib1g-dev bison flex gfortran g++ cmake swig grace gettext python3 python3-dev python3-numpy libboost-python-dev libboost-numpy-dev tk locales && locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /root
#COPY ./dockerdata/aster-full-src-14.4.0-1.noarch.tar.gz /root
#RUN tar -xzf /root/aster-full-src-14.4.0-1.noarch.tar.gz && rm /root/aster-full-src-14.4.0-1.noarch.tar.gz
RUN curl -f -SLk https://www.code-aster.org/FICHIERS/aster-full-src-14.4.0-1.noarch.tar.gz | tar -xzC /root
ENV ASTER_BUILD=/root/aster-full-src-14.4.0
ENV ASTER_INSTALL=/opt/aster
WORKDIR $ASTER_BUILD
RUN python3 setup.py install --prefix=$ASTER_INSTALL --noprompt && $ASTER_INSTALL/bin/as_run --test forma02a && rm -Rf /opt/aster/14.4/share/aster/tests
ENV MFRONT_INSTALL=$ASTER_INSTALL/mfront-3.2.1
ENV MFRONT=$MFRONT_INSTALL/bin/mfront
ENV TFEL_CONFIG=$MFRONT_INSTALL/bin/tfel-config
ENV PATH=$PATH:$MFRONT_INSTALL/bin

RUN echo "vers : STABLE:/opt/aster/14.4/share/aster" >> $ASTER_INSTALL/etc/codeaster/aster

FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y sudo git doxygen nastran libblas-dev liblapack-dev zlib1g g++ cmake python3 python3-numpy libboost-all-dev locales && locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /opt/aster
COPY --from=0 /opt/aster .

ENV ASTER_INSTALL=/opt/aster
ENV MED_INSTALL=$ASTER_INSTALL/public/med-4.0.0
ENV HDF_INSTALL=$ASTER_INSTALL/public/hdf5-1.10.3
ENV CXXFLAGS="-isystem $MED_INSTALL/include -isystem $HDF_INSTALL/include"
RUN sudo ln -s $ASTER_INSTALL/bin/as_run /usr/local/bin
ENV HDF5_ROOT=$HDF_INSTALL

RUN addgroup --gid 1777 vega && adduser --gecos ,,,, --shell /bin/bash -u 1777 --gid 1777 --disabled-password vega && echo "vega ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && echo 'export PATH=$ASTER_INSTALL/bin:$NASTRAN_INSTALL/bin:$PATH' >> /home/vega/.bashrc

USER vega
WORKDIR /home/vega

#RUN git clone --depth=50 --branch=master https://github.com/Alneos/vega.git /home/vega/vegapp && mkdir /home/vega/vegapp/build && cd /home/vega/vegapp/build && cmake -DHDF5_LIBRARIES=$HDF_INSTALL/lib/libhdf5.a -DHDF5_INCLUDE_DIRS=$HDF_INSTALL/include -DMEDFILE_C_LIBRARIES=$MED_INSTALL/lib/libmedC.a -DMEDFILE_INCLUDE_DIRS=$MED_INSTALL/include -DCMAKE_BUILD_TYPE=Debug -DRUN_SYSTUS=OFF .. && make -j


