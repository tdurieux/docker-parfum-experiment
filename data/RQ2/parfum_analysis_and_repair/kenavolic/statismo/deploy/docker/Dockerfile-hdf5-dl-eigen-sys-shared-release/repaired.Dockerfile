FROM ubuntu:bionic

ARG git_branch=develop

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https ca-certificates gnupg software-properties-common wget && rm -rf /var/lib/apt/lists/*;
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -

RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && apt-get update

RUN apt-get install --no-install-recommends -y git cmake tar mesa-common-dev freeglut3-dev build-essential && rm -rf /var/lib/apt/lists/*;

# Eigen system deployed with cmake
WORKDIR "/usr/src/"
RUN wget https://gitlab.com/libeigen/eigen/-/archive/3.3.5/eigen-3.3.5.tar.gz
RUN tar -xvzf eigen-3.3.5.tar.gz --one-top-level=eigen --strip-components 1 && rm eigen-3.3.5.tar.gz
WORKDIR "/usr/src/eigen"
RUN mkdir build
WORKDIR "/usr/src/eigen/build"
RUN cmake .. -DCMAKE_INSTALL_PREFIX=/usr/src/eigen/dist
RUN make install

# Statismo
RUN git clone https://github.com/kenavolic/statismo --branch $git_branch /usr/src/statismo

WORKDIR "/usr/src/statismo"
RUN mkdir build
WORKDIR "/usr/src/statismo/build"

RUN cmake ../superbuild -DCMAKE_INSTALL_PREFIX=/usr/src/statismo/dist -DBUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DBUILD_WRAPPING=OFF -DBUILD_DOCUMENTATION=OFF -DBUILD_CLI_TOOLS=OFF -DBUILD_CLI_TOOLS_DOC=OFF \
  -DVTK_SUPPORT=OFF -DITK_SUPPORT=OFF -DUSE_SYSTEM_EIGEN=ON -DUSE_SYSTEM_HDF5=OFF -DEigen3_DIR=/usr/src/eigen/dist/share/eigen3/cmake

RUN make -j4

WORKDIR "/usr/src/statismo/build/Statismo-build"

RUN make install

# Tests
RUN ctest
