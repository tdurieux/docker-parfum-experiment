FROM centos:8

RUN dnf -y install dnf-plugins-core epel-release && \
    dnf config-manager --set-enabled PowerTools && \
    dnf -y update && \
    dnf -y install \
      blas-devel \
      boost-devel \
      cmake3 \
      fftw-devel \
      gcc-c++ \
      gcc-gfortran \
      git \
      vim \
      lldb \
      gmp-devel \
      hdf5-devel \
      lapack-devel \
      make \
      openmpi-devel \
      python3-devel \
      python3-mako \
      python3-matplotlib \
      python3-mpi4py-openmpi \
      python3-numpy \
      python3-pip \
      python3-pytz \
      python3-scipy \
      python3-virtualenv

# for openmpi
ENV PYTHON_VERSION=3.6 \
    CC=gcc CXX=g++ \
    PATH=/usr/lib64/openmpi/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/lib64/openmpi/lib \
    PKG_CONFIG_PATH=/usr/lib64/openmpi/lib/pkgconfig \
    MPI_PYTHON3_SITEARCH=/usr/lib64/python3.6/site-packages/openmpi \
    OMPI_MCA_btl=^uct