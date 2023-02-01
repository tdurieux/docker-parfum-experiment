FROM lukasgd/korali_cscs_ci_cpu:base

# Docker build context must be the root directory of the `git clone`
COPY . korali

RUN cd korali; CC=gcc CXX=g++ meson setup build --prefix=/usr/local --buildtype=release -Donednn=true -Dmpi=true
RUN cd korali; ninja -C build
RUN cd korali; meson install -C build

ENV PYTHONPATH=/usr/local/lib/python3/dist-packages/:$PYTHONPATH

# Additional layers to build tests
RUN cd korali/examples/features/running.cxx && make -j4
RUN cd korali/examples/features/running.mpi.cxx && make -j4