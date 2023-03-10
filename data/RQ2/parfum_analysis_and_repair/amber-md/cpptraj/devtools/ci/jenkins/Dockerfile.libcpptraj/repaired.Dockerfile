FROM condaforge/miniforge3

# noninteractive to try and fix tzdata issue
RUN mkdir /cpptraj && \
    mkdir /.conda /.local && \
    apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y gfortran gcc g++ bzip2 libfftw3-dev automake make libbz2-dev \
                       mpich libmpich-dev zlib1g-dev netcdf-bin libnetcdf-dev \
                       liblapack-dev libarpack2-dev && rm -rf /var/lib/apt/lists/*;

# Make it so Jenkins UIDs can install python packages to miniconda
RUN chmod -R a+w /opt/conda && \
    chmod -R a+w /.conda && \
    chmod -R a+w /.local

COPY . /cpptraj

ENV CPPTRAJHOME "/cpptraj"

RUN cd /cpptraj && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" -openmp -shared gnu && \
    make -j4 libcpptraj

