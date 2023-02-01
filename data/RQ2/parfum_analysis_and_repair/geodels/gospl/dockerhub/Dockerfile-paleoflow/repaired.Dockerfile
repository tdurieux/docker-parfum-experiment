FROM ubuntu:18.04
MAINTAINER Tristan Salles

#Install ubuntu libraires and packages
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y wget python3-pip && rm -rf /var/lib/apt/lists/*;

#Download pygplates and install it
ADD pygplates_2.0_amd64.deb .
RUN apt-get install --no-install-recommends -y ./pygplates_2.0_amd64.deb && rm -rf /var/lib/apt/lists/*;
RUN rm pygplates_2.0_amd64.deb

Env PYTHONPATH ${PYTHONPATH}:/usr/lib:/usr/lib/pygplates/revision26/

# install all the python and ipython notebook requirements
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir numpy scipy matplotlib jupyter pandas sympy nose
RUN pip3 install --no-cache-dir ipyparallel pyproj pyshp Pillow
RUN pip3 install --no-cache-dir moviepy

RUN apt-get install -y --no-install-recommends libgeos-dev && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/matplotlib/basemap/archive/v1.2.1rel.tar.gz
RUN tar -vxf v1.2.1rel.tar.gz && rm v1.2.1rel.tar.gz
RUN cd basemap-1.2.1rel/ && python3 setup.py install_lib
RUN rm -rf basemap-1.2.1rel/ v1.2.1rel.tar.gz

RUN pip3 install --no-cache-dir Cython
RUN apt-get install --no-install-recommends -y libproj-dev && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/SciTools/cartopy/archive/v0.18.0b1.tar.gz
RUN tar -vxf v0.18.0b1.tar.gz && rm v0.18.0b1.tar.gz
RUN cd cartopy-0.18.0b1/ && python3 setup.py install
RUN rm -rf cartopy-0.18.0b1/ v0.18.0b1.tar.gz

RUN pip3 install --no-cache-dir statistics netCDF4

RUN pip3 uninstall -y shapely
RUN pip3 install --no-cache-dir shapely --no-binary shapely

# install things
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
        bash-completion \
        build-essential \
        git \
        python3-minimal \
        python3-dev \
        python3-pip \
        libxml2-dev \
        xorg-dev \
        ssh \
        curl \
        libfreetype6-dev \
        libpng-dev \
        libxft-dev \
        xvfb \
        python3-tk \
        mesa-utils \
        rsync \
        vim \
        less \
        xauth \
        swig \
        python3-dbg \
        cmake \
        python3-setuptools \
        wget \
        zlib1g \
        gzip \
        gfortran  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG MPICH_VERSION="3.3"
ARG MPICH_CONFIGURE_OPTIONS="--enable-fast=all,O3 --prefix=/opt/mpich"
ARG MPICH_MAKE_OPTIONS="-j4"
WORKDIR /tmp/mpich-build
RUN wget https://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz && \
    tar xvzf mpich-${MPICH_VERSION}.tar.gz && \
    cd mpich-${MPICH_VERSION} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" ${MPICH_CONFIGURE_OPTIONS} && \
    make ${MPICH_MAKE_OPTIONS} && \
    make install && \
    ldconfig && \
    cd /tmp && \
    rm -fr * && rm mpich-${MPICH_VERSION}.tar.gz

ENV MPI_DIR=/opt/mpich
ENV PATH=${MPI_DIR}/bin:$PATH


ENV LANG=C.UTF-8
# Install setuptools and wheel first, needed by plotly
RUN pip3 install --no-cache-dir -U setuptools && \
    pip3 install --no-cache-dir -U wheel && \
    pip3 install --no-cache-dir packaging \
        appdirs \
        numpy \
        jupyter \
        plotly \
        matplotlib \
        pillow \
        pyvirtualdisplay \
        ipython \
        ipyparallel \
        pint \
        scipy \
        tabulate \
        scons && \
    env MPICC=${MPI_DIR}/mpicc MPICXX=${MPI_DIR}/mpicxx MPIFC=${MPI_DIR}/mpifort python3 -m pip install --no-cache-dir mpi4py


WORKDIR /tmp/petsc-build
ARG PETSC_VERSION="3.11.2"
RUN wget https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-${PETSC_VERSION}.tar.gz && \
    tar zxf petsc-lite-${PETSC_VERSION}.tar.gz && cd petsc-${PETSC_VERSION} && rm petsc-lite-${PETSC_VERSION}.tar.gz


RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1

RUN cd /tmp/petsc-build/petsc-${PETSC_VERSION}; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-debugging=0 --prefix=/opt/petsc \
                --COPTFLAGS="-g -O3" --CXXOPTFLAGS="-g -O3" --FOPTFLAGS="-g -O3" \
                --with-zlib=1 \
                --download-fblaslapack=1 \
                --download-ctetgen=1 \
                --download-triangle=1 \
                --download-hdf5=1 \
                --download-mumps=1 \
                --download-parmetis=1 \
                --download-eigen=1 \
                --download-metis=1 \
                --download-hypre=1 \
                --download-scalapack=1 \
                --download-pragmatic=1 \
                --useThreads=1 \
                --with-shared-libraries \
                --with-cxx-dialect=C++11 && \
    make PETSC_DIR=/tmp/petsc-build/petsc-${PETSC_VERSION} PETSC_ARCH=arch-linux-c-opt all && \
    make PETSC_DIR=/tmp/petsc-build/petsc-${PETSC_VERSION} PETSC_ARCH=arch-linux-c-opt install && \
    make PETSC_DIR=/opt/petsc PETSC_ARCH="" test && \
    cd /tmp && \
    rm -fr *

ENV PETSC_DIR=/opt/petsc
ENV PATH=${PETSC_DIR}/bin:$PATH

ENV PYTHONPATH $PYTHONPATH:/usr/lib
RUN CC=h5pcc HDF5_MPI="ON" HDF5_DIR=${PETSC_DIR} python3 -m pip install --no-cache-dir --no-binary=h5py h5py && \
    python3 -m pip install --no-cache-dir petsc4py==3.11.0

# install extras in a new layer
RUN python3 -m pip install --no-cache-dir \
        ipython \
        jupyter

ENV PETSC_DIR=/opt/petsc
ENV PETSC_ARCH=arch-linux-c-opt
ENV PYTHONPATH ${PYTHONPATH}:/usr/lib:/usr/lib/pygplates/revision26/

# install things
RUN apt-get update -qq && \
    apt-get install -yq --no-install-recommends \
        cdftools \
        cmake \
        build-essential \
        libcurl4-gnutls-dev \
        libnetcdf-dev \
        gawk \
        gmt-gshhg-full \
        gmt-dcw \
        graphicsmagick \
        ffmpeg \
        xdg-utils \
        gdal-bin \
        libgdal-dev \
        libfftw3-dev \
        libpcre3-dev \
        liblapack-dev \
        libblas-dev \
        libglib2.0-dev \
        ghostscript && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install --no-cache-dir setuptools wheel && \
    python3 -m pip install --no-cache-dir \
    pathlib \
    pandas \
    meshio \
    shapely \
    meshplex \
    ruamel.yaml \
    stripy

# install GMT
RUN wget https://github.com/GenericMappingTools/gmt/releases/download/6.0.0/gmt-6.0.0-src.tar.xz && \
    tar -xvf gmt-6.0.0-src.tar.xz && \
    cd gmt-6.0.0/cmake/; rm gmt-6.0.0-src.tar.xz cp ConfigUserTemplate.cmake ../ConfigUser.cmake && \
    dpkg -L gmt-gshhg-full && \
    dpkg -L gmt-dcw

RUN mkdir gmt-6.0.0/build && \
    cd gmt-6.0.0/build && \
    cmake ..

RUN cd gmt-6.0.0/build && \
    cmake --build . && \
    cmake --build . --target install

RUN rm -rf gmt-6.0.0-src.tar.xz && \
    rm -rf gmt-6.0.0

RUN apt-get install -yq --no-install-recommends python3-gdal && rm -rf /var/lib/apt/lists/*;

# install gopspl
WORKDIR /live/lib
RUN git clone --depth=1 https://github.com/Geodels/gospl.git && \
    cd gospl && \
    export F90=gfortran && \
    export PETSC_DIR=/opt/petsc && \
    export PETSC_ARCH=arch-linux-c-opt && \
    python3 setup.py install

#RUN git clone --depth=1 https://github.com/badlands-model/badlands.git && \
#    cd badlands/badlands && \
#    python3 setup.py install --user
RUN python3 -m pip install --no-cache-dir badlands==2.0.24

# setup space for working in
VOLUME /live/share
WORKDIR /live

ENV LD_LIBRARY_PATH=/live/lib/:/live/share


# Add Tini. Tini operates as a process subreaper for jupyter. This prevents
# kernel crashes.
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]


EXPOSE 8888

# launch notebook
ADD run-jupyter.sh /usr/local/bin/run-jupyter.sh
RUN chmod +x /usr/local/bin/run-jupyter.sh
ADD bashrc-term /root/.bashrc
CMD /usr/local/bin/run-jupyter.sh
