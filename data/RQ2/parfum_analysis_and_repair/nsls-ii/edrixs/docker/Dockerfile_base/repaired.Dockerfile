FROM ubuntu:18.04
WORKDIR /project

RUN apt-get update \
    # add user rixs \
    && apt-get install --no-install-recommends -y sudo \
    && useradd -ms /bin/bash rixs \
    && echo "rixs:rixs" | chpasswd \
    && adduser rixs sudo \
    # turn off the error reports from openmpi
    && echo "export OMPI_MCA_btl_vader_single_copy_mechanism=none" >> ~/.bashrc \
    && echo "export OMPI_MCA_btl_vader_single_copy_mechanism=none" >> /home/rixs/.bashrc \
    # install deps
    && apt-get install --no-install-recommends -y gcc libgcc-7-dev g++ gfortran ssh wget vim libtool autoconf make \
    && apt-get install --no-install-recommends -y python3 libpython3-dev python3-pip ipython3 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 10 \
    && update-alternatives --install /usr/bin/ipython ipython /usr/bin/ipython3 10 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10 \
    # install openblas
    && wget https://github.com/xianyi/OpenBLAS/archive/v0.3.6.tar.gz \
    && tar -xzf v0.3.6.tar.gz \
    && make -C OpenBLAS-0.3.6 CC=gcc FC=gfortran \
    && make -C OpenBLAS-0.3.6 PREFIX=/usr/local install \
    && rm -rf OpenBLAS-0.3.6 v0.3.6.tar.gz \
    # install openmpi
    && wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.4.tar.bz2 \
    && tar -xjf openmpi-3.1.4.tar.bz2 \
    && cd openmpi-3.1.4 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CC=gcc CXX=g++ FC=gfortran \
    && make \
    && make install \
    && cd .. \
    && rm -rf openmpi-3.1.4 openmpi-3.1.4.tar.bz2 \
    # install arpack-ng
    && wget https://github.com/opencollab/arpack-ng/archive/3.6.3.tar.gz \
    && tar -xzf 3.6.3.tar.gz \
    && cd arpack-ng-3.6.3 \
    && export LD_LIBRARY_PATH="/usr/local/lib:\$LD_LIBRARY_PATH" \
    && ./bootstrap \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-mpi --with-blas="-L/usr/local/lib/ -lopenblas" FC=gfortran F77=gfortran MPIFC=mpif90 MPIF77=mpif90 \
    && make \
    && make install \
    && cd .. \
    && rm -rf arpack-ng-3.6.3 3.6.3.tar.gz \
    # install python deps
    && pip install --no-cache-dir numpy scipy sympy matplotlib sphinx mpi4py jupyter jupyterlab==2.1.3 prompt-toolkit==1.0.15 \
    # set env
    && echo "export LD_LIBRARY_PATH=/usr/local/lib:\$LD_LIBRARY_PATH" >> ~/.bashrc \
    && echo "export LD_LIBRARY_PATH=/usr/local/lib:\$LD_LIBRARY_PATH" >> /home/rixs/.bashrc && rm -rf /var/lib/apt/lists/*;
