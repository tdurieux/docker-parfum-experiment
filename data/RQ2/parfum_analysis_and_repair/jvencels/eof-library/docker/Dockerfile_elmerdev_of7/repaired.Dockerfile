ARG BASE_IMAGE=hfdresearch/swak4foamandpyfoam:latest-v7.0

# Alternatively, you can use Docker flag
# --build-arg BASE_IMAGE=openfoam/openfoam7-paraview56:latest

FROM $BASE_IMAGE

USER root

RUN apt-get -y update && \
  apt-get install --no-install-recommends -y \
    gcc \
    cmake \
    g++ \
    gfortran \
    libopenblas-dev \
    git && rm -rf /var/lib/apt/lists/*;

# Elmer
RUN cd /opt && \
  git clone https://github.com/ElmerCSC/elmerfem.git && \
  cd elmerfem && \
  git log --pretty=oneline | head -n 10 | tee -a /opt/elmerBuild.log && \
  mkdir build && \
  cd build && \
  cmake -DWITH_MPI=TRUE -DCMAKE_BUILD_TYPE=Release ../ | tee -a /opt/elmerBuild.log && \
  make -j install | tee -a /opt/elmerBuild.log
