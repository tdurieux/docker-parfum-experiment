# --- runtime-base ---
FROM fedora:31 as runtime-base

LABEL description="Runtime base container"
LABEL maintainer="jan.behrens@kit.edu"

COPY Docker/packages.runtime packages
RUN dnf update -y \
 && dnf install -y $(cat packages) \
 && rm /packages

# --- build-base ---
FROM runtime-base as build-base

LABEL description="Build base container"

COPY Docker/packages.build packages
RUN dnf update -y \
 && dnf install -y $(cat packages) \
 && rm /packages

# --- build ---
FROM build-base as build

LABEL description="Build container"

COPY . /usr/src/kasper
RUN cd /usr/src/kasper && \
    mkdir -p build && \
    pushd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_INSTALL_PREFIX=/usr/local \
          -DBUILD_UNIT_TESTS=ON \
          -DKASPER_USE_ROOT=ON \
          -DKASPER_USE_VTK=ON \
          -DKASPER_USE_TBB=ON \
          -DKEMField_USE_OPENCL=OFF \
       .. && \
    make -j $((($(nproc)+1)/2)) && \
    make install && \
    popd

# --- runtime ---