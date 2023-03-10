FROM quay.io/tianyikillua/base:latest

# Variables
ENV HDF5_VER=1.10.3
ENV MED_VER=4.0.0
ENV ASTER_VER=14.4

ENV ASTER_FULL_SRC="https://code-aster.org/FICHIERS/aster-full-src-14.4.0-1.noarch.tar.gz"
ENV ASTER_INSTALL=/opt/aster
ENV PUBLIC=$ASTER_INSTALL/public

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Get Ubuntu updates and basic packages
USER root
RUN apt-get update && \
    apt-get upgrade -y --with-new-pkgs -o Dpkg::Options::="--force-confold" && \
    apt-get install --no-install-recommends -y \
    patch \
    make cmake \
    grace \
    zlib1g-dev \
    tk bison flex \
    libglu1-mesa libxcursor-dev \
    liblapack-dev libblas-dev \
    libboost-python-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tmp

# Download and install the latest stable version
RUN wget --no-check-certificate --quiet ${ASTER_FULL_SRC} -O aster_full.tar.gz && \
    mkdir aster_full && tar xf aster_full.tar.gz -C aster_full --strip-components 1 && \
    cd aster_full && \
    python3 setup.py install --prefix ${ASTER_INSTALL} --noprompt && rm aster_full.tar.gz

ENV MFRONT_INSTALL=$ASTER_INSTALL/mfront-3.2.1
ENV MFRONT=$MFRONT_INSTALL/bin/mfront
ENV TFEL_CONFIG=$MFRONT_INSTALL/bin/tfel-config
ENV PATH=$PATH:$MFRONT_INSTALL/bin

RUN echo "vers : STABLE:/opt/aster/14.4/share/aster" >> $ASTER_INSTALL/etc/codeaster/aster
RUN apt-get update && \
    apt-get upgrade -y --with-new-pkgs -o Dpkg::Options::="--force-confold" && \
    apt-get install --no-install-recommends -y git nastran libboost-all-dev && rm -rf /var/lib/apt/lists/*;
ENV MED_INSTALL=$ASTER_INSTALL/public/med-4.0.0
ENV HDF_INSTALL=$ASTER_INSTALL/public/hdf5-1.10.3
ENV CXXFLAGS="-isystem $MED_INSTALL/include -isystem $HDF_INSTALL/include"
RUN ln -s $ASTER_INSTALL/bin/as_run /usr/local/bin
ENV HDF5_ROOT=$HDF_INSTALL
RUN git clone --depth=50 --branch=master https://github.com/Alneos/vega.git /home/vega/vegapp && \
    mkdir /home/vega/vegapp/build && \
    cd /home/vega/vegapp/build && \
    cmake -DHDF5_LIBRARIES=$HDF_INSTALL/lib/libhdf5.a -DHDF5_INCLUDE_DIRS=$HDF_INSTALL/include -DMEDFILE_C_LIBRARIES=$MED_INSTALL/lib/libmedC.a -DMEDFILE_INCLUDE_DIRS=$MED_INSTALL/include -DCMAKE_BUILD_TYPE=Debug -DRUN_SYSTUS=OFF .. && \
    make -j
