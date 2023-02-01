FROM ubuntu:22.04

WORKDIR /data
RUN apt-get update
RUN apt-get install --no-install-recommends -y libopenmpi-dev openmpi-bin libhdf5-openmpi-dev git pkg-config gcc libaio-dev libpnetcdf-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sudo make && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/hpc/ior.git
RUN cd ior ; ./bootstrap
RUN cd ior ; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-aio --with-hdf5 --with-ncmpi LDFLAGS=-L/usr/lib/x86_64-linux-gnu/hdf5/openmpi CFLAGS=-I/usr/include/hdf5/openmpi && make -j

# librados-dev
