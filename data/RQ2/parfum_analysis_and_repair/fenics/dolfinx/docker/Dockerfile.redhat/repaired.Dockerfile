# Dockerfile for testing DOLFINx in Red Hat-compatible distributions.  Must be
# built locally and pushed.
#
# docker build -f Dockerfile.redhat -t docker.io/fenicsproject/test-env:latest-redhat .
# docker push docker.io/fenicsproject/test-env:latest-redhat
FROM rockylinux/rockylinux:8

ARG BUILD_NP=16

ARG BOOST_VERSION=1.77.0
ARG BOOST_VERSION_UNDERSCORES=1_77_0
ARG HDF5_SERIES=1.12
ARG HDF5_PATCH=2
ARG PETSC_VERSION=3.17.1
ARG PYBIND11_VERSION=2.9.2
ARG NUMPY_VERSION=1.21.6
ARG MPICH_VERSION=4.0.2
ARG XTENSOR_VERSION=0.24.2
ARG XTL_VERSION=0.7.4

WORKDIR /tmp

RUN dnf -y update && \
    dnf install -y dnf-plugins-core && \
    dnf config-manager --set-enabled powertools && \
    dnf install -y epel-release && \
    dnf -y install \
      pugixml-devel \
      # Required by PETSc build
      bison \
      cmake \
      # Required by PETSc build
      flex \
      gcc-toolset-11 \
      # Utility
      git \
      # Only in PowerTools repo
      ninja-build \
      openblas-devel \
      python39 \
      python39-devel \
      python39-pip && \
    dnf -y clean all && \
    rm -rf /var/cache

# Permanently enable GCC 11 toolset
ENV DEVTOOLSET_ROOTPATH="/opt/rh/gcc-toolset-11/root"
ENV PATH="${DEVTOOLSET_ROOTPATH}/usr/bin:${PATH}"
ENV LD_LIBRARY_PATH="${DEVTOOLSET_ROOTPATH}/usr/lib64:${DEVTOOLSET_ROOTPATH}/usr/lib:${DEVTOOLSET_ROOTPATH}/usr/lib64/dyninst:${DEVTOOLSET_ROOTPATH}/usr/lib/dyninst:/usr/local/lib64:${LD_LIBRARY_PATH}"

# Build MPICH (see https://github.com/pmodels/mpich/issues/5811)
RUN curl -f -L -O http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz && \
    tar -xf mpich-${MPICH_VERSION}.tar.gz && \
    cd mpich-${MPICH_VERSION} && \
    FCFLAGS=-fallow-argument-mismatch FFLAGS=-fallow-argument-mismatch ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-device=ch4:ofi --enable-shared --prefix=/usr/local && \
    make -j${BUILD_NP} install && \
    rm -rf /tmp/* && rm mpich-${MPICH_VERSION}.tar.gz

# First set of dependencies for building and running Python DOLFINx
# Second set of dependencies for running DOLFINx tests
RUN python3 -m pip install --no-binary="numpy" --no-cache-dir cffi numba numpy==${NUMPY_VERSION} mpi4py pybind11==${PYBIND11_VERSION} wheel && \
    python3 -m pip install --no-cache-dir cppimport pytest pytest-xdist scipy matplotlib

# Build PETSc
RUN curl -f -L -O http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-${PETSC_VERSION}.tar.gz && \
    mkdir petsc && \
    tar -xf petsc-lite-${PETSC_VERSION}.tar.gz -C petsc --strip-components=1 && \
    cd petsc && \
    python3 ./configure \
      --with-shared-libraries \
      --with-fortran-bindings=no \
      --with-scalar-type=real \
      --with-64-bit-indices=yes \
      --with-debugging=yes \
      --download-ptscotch \
      --download-hypre \
      --download-metis \
      --download-mumps \
      --download-scalapack \
      --download-superlu_dist \
      --prefix=/usr/local \
      --with-make-np=${BUILD_NP} && \
    make all && \
    make install && \
    cd src/binding/petsc4py && \
    PETSC_DIR=/usr/local python3 -m pip install --no-cache-dir . && \
    rm -rf /tmp/* && rm petsc-lite-${PETSC_VERSION}.tar.gz

ENV PETSC_DIR=/usr/local

# System Boost too old
RUN curl -f -L -O https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION_UNDERSCORES}.tar.gz && \
    tar -xf boost_${BOOST_VERSION_UNDERSCORES}.tar.gz && \
    cd boost_${BOOST_VERSION_UNDERSCORES} && \
    ./bootstrap.sh --prefix=/usr/local && \
    ./b2 -j ${BUILD_NP} --with-timer --with-filesystem --with-program_options cxxflags="-fPIC -std=c++11" install && \
    rm -rf /tmp/* && rm boost_${BOOST_VERSION_UNDERSCORES}.tar.gz

# Build HDF5
RUN curl -f -L -O https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_SERIES}/hdf5-${HDF5_SERIES}.${HDF5_PATCH}/src/hdf5-${HDF5_SERIES}.${HDF5_PATCH}.tar.gz && \
    tar -xf hdf5-${HDF5_SERIES}.${HDF5_PATCH}.tar.gz && \
    cd hdf5-${HDF5_SERIES}.${HDF5_PATCH} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local --enable-parallel --enable-shared --enable-static=no && \
    make -j${BUILD_NP} install && \
    rm -rf /tmp/* && rm hdf5-${HDF5_SERIES}.${HDF5_PATCH}.tar.gz

# Install xtensor libraries
RUN git clone -b ${XTL_VERSION} --single-branch https://github.com/xtensor-stack/xtl.git && \
    cd xtl && \
    mkdir -p build && \
    cd build && \
    cmake -G Ninja ../ && \
    ninja install && \
    cd ../../ && \
    git clone -b ${XTENSOR_VERSION} --single-branch https://github.com/xtensor-stack/xtensor.git && \
    cd xtensor && \
    mkdir -p build && \
    cd build && \
    cmake -G Ninja ../ && \
    ninja install && \
    rm -rf /tmp/*

# RHEL pkgconfig does not look here by default. Setting this probably better
# than forcing install into 'system path' or hacking in DOLFINx pkgconfig.py
# code.
ENV PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig
