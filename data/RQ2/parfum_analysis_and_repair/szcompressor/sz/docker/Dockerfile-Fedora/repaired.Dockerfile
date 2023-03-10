FROM fedora:29
RUN dnf update -y && \
    dnf install -y  \
        CUnit-devel \
        cmake \
        ctags \
        fftw-devel \
        gcc \
        gcc-c++ \
        libzstd-devel \
        netcdf-devel \
        ninja-build \
        python3-devel \
        python-numpy \
        python3-numpy \
        zlib-devel && \
    dnf clean all
COPY . /build/
WORKDIR /build/
RUN rm -rf build && \
    mkdir -p build && \
    cd build && \
    cmake .. -G Ninja -DBUILD_PYTHON_WRAPPER=on && \
    ninja