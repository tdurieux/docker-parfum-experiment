FROM python:3.6-stretch
MAINTAINER Chris Ostrouchov "chris.ostrouchov@gmail.com"

ARG VERSION="patch_11May2018"
ARG PACKAGES="asphere body class2 colloid compress coreshell dipole granular kspace manybody mc misc molecule opt peri qeq replica rigid shock snap srd user-reaxc"
ARG LMP_INCLUDES="-DLAMMPS_EXCEPTIONS -DLAMMPS_GZIP -DLAMMPS_MEMALIGN=64"

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget build-essential ssh zlib1g-dev \
                       libfftw3-dev libopenblas-dev libopenmpi-dev && \
    rm -rf /var/lib/apt/lists/*

# mpi based shared library (needed by lammps-cython)
# serial exucutable (needed by pymatgen_lammps)
RUN wget -q https://github.com/lammps/lammps/archive/$VERSION.tar.gz && \
    tar -xf $VERSION.tar.gz  && \
    cd lammps-$VERSION/src && \
    for pack in $PACKAGES; do make "yes-$pack"; done && \
    make mode=shlib mpi -j4 LMP_INC="$LMP_INCLUDES" && \
    make serial && \
    cp lmp_serial /usr/local/bin/lammps && \
    cp liblammps_mpi.so /usr/local/lib/liblammps.so && \
    mkdir /usr/local/include/lammps && \
    cp *.h /usr/local/include/lammps && \
    cd ../.. && \
    rm -rf lammps-$VERSION $VERSION.tar.gz && \
    ldconfig
