FROM nvidia/cuda:9.2-devel-ubuntu16.04

LABEL com.pyfr.version="1.8.0"
LABEL com.python.version="3.5"

# Install system dependencies
# Metis is a library for mesh partitioning:
# http://glaros.dtc.umn.edu/gkhome/metis/metis/overview
RUN apt-get update && apt-get install -y   \
        unzip                       \
        wget                        \
        build-essential             \
        gfortran-5                  \
        strace                      \
        realpath                    \
        libopenblas-dev             \
        liblapack-dev               \
        python3-dev                 \
        python3-setuptools          \
        python3-pip                 \
        libhdf5-dev                 \
        libmetis-dev                \
        --no-install-recommends  && \
    rm -rf /var/lib/apt/lists/*

# Install MPICH 3.1.4
RUN wget -q https://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz && \
    tar xvf mpich-3.1.4.tar.gz && \
    cd mpich-3.1.4 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-fortran --prefix=/usr && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf mpich-3.1.4.tar.gz mpich-3.1.4 && \
    ldconfig

# Create new user
RUN useradd docker
WORKDIR /home/docker

# Install Python dependencies
RUN pip3 install --no-cache-dir numpy >=1.8 \
                 pytools >=2016.2.1 \
                 mako >=1.0.0 \
                 appdirs >=1.4.0 \
                 mpi4py >=2.0 && \
    pip3 install --no-cache-dir pycuda >=2015.1 \
                 h5py >=2.6.0 && \
    wget -q -O GiMMiK-2.1.tar.gz    \
        https://github.com/vincentlab/GiMMiK/archive/v2.1.tar.gz && \
    tar -xvzf GiMMiK-2.1.tar.gz && \
    cd GiMMiK-2.1 && \
    python3 setup.py install && \
    cd .. && \
    rm -rf GiMMiK-2.1.tar.gz GiMMiK-2.1

# Set base directory for pyCUDA cache
ENV XDG_CACHE_HOME /tmp

# Install PyFR
RUN wget -q -O PyFR-1.8.0.zip https://www.pyfr.org/download/PyFR-1.8.0.zip && \
    unzip -qq PyFR-1.8.0.zip && \
    cd PyFR-1.8.0 && \
    python3 setup.py install && \
    cd .. && \
    rm -rf PyFR-1.8.0.zip

CMD ["pyfr --help"]
