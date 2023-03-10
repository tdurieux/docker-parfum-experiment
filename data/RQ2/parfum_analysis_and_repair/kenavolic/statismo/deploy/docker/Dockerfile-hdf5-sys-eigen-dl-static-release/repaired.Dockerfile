FROM ubuntu:bionic

ARG git_branch=develop

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https ca-certificates gnupg software-properties-common wget && rm -rf /var/lib/apt/lists/*;
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -

RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && apt-get update

RUN apt-get install --no-install-recommends -y git cmake tar mesa-common-dev freeglut3-dev build-essential && rm -rf /var/lib/apt/lists/*;

# HDF5 system
WORKDIR "/usr/src/"
RUN wget https://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.2/src/hdf5-1.10.2.tar.gz
RUN tar -xvzf hdf5-1.10.2.tar.gz --one-top-level=hdf5 --strip-components 1 && rm hdf5-1.10.2.tar.gz
WORKDIR "/usr/src/hdf5"
RUN mkdir build
WORKDIR "/usr/src/hdf5/build/"
RUN cmake .. -DCMAKE_INSTALL_PREFIX=/usr/src/hdf5/dist -DCMAKE_BUILD_TYPE=Release -DHDF5_ENABLE_Z_LIB_SUPPORT=OFF -DHDF5_BUILD_CPP_LIB:BOOL=ON -DBUILD_SHARED_LIBS=OFF -DHDF5_BUILD_TOOLS=OFF -DBUILD_TESTING=OFF -DHDF5_BUILD_EXAMPLES=OFF -DHDF5_BUILD_JAVA=OFF
RUN make install 

# Statismo
RUN git clone https://github.com/kenavolic/statismo --branch $git_branch /usr/src/statismo

WORKDIR "/usr/src/statismo"
RUN mkdir build
WORKDIR "/usr/src/statismo/build"

RUN cmake ../superbuild -DCMAKE_INSTALL_PREFIX=/usr/src/statismo/dist -DBUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DBUILD_WRAPPING=OFF -DBUILD_DOCUMENTATION=OFF -DBUILD_CLI_TOOLS=OFF -DBUILD_CLI_TOOLS_DOC=OFF \
  -DVTK_SUPPORT=OFF -DITK_SUPPORT=OFF -DUSE_SYSTEM_EIGEN=OFF -DUSE_SYSTEM_HDF5=ON -DHDF5_DIR=/usr/src/hdf5/dist/share/cmake/hdf5

RUN make -j4

WORKDIR "/usr/src/statismo/build/Statismo-build"

RUN make install

# Tests
RUN ctest
