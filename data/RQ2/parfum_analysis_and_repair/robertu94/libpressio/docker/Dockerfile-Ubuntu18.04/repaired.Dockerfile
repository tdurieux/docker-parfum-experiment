FROM ubuntu:18.04 as builder
#contrary to the Filesystem Hierarchy Standard,
#warning ubuntu does not allow libraries to be installed in /usr/lib, use /usr/local instead
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y doxygen graphviz libhdf5-dev g++ git swig ninja-build libzstd-dev pkg-config \
      libfftw3-dev python3-dev python3-numpy wget zlib1g-dev libmagick++-dev libblosc-dev && \
    wget -O cmake.sh https://github.com/Kitware/CMake/releases/download/v3.14.6/cmake-3.14.6-Linux-x86_64.sh && \
    sh cmake.sh --skip-licence --exclude-subdir --prefix=/usr/local && \
    apt clean -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/LLNL/zfp /src/zfp && \
    git clone https://github.com/disheng222/sz /src/sz && \
    git clone https://github.com/CODARcode/MGARD /src/mgard && \
    git clone https://github.com/llnl/fpzip /src/fpzip && \
    cd /src/sz && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -G Ninja && \
    cmake --build . && \
    ninja install && \
    \
    cd /src/zfp && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_TESTING=OFF -G Ninja && \
    cmake --build . && \
    ninja install && \
    \
    cd /src/mgard && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=lib -DBUILD_TESTING=OFF -G Ninja && \
    cmake --build . && \
    ninja install && \
    \
    cd /src/fpzip && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_TESTING=OFF -G Ninja && \
    cmake --build . && \
    ninja install
COPY . /src/libpressio
RUN cd /src/libpressio && \
    rm -rf build && \
    mkdir build && \
    cd build && \
    cmake ..  \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DBUILD_TESTING=ON \
      -DLIBPRESSIO_HAS_SZ=ON \
      -DLIBPRESSIO_HAS_ZFP=ON \
      -DLIBPRESSIO_HAS_MGARD=ON \
      -DLIBPRESSIO_HAS_MGARD=ON \
      -DLIBPRESSIO_HAS_BLOSC=ON \
      -DLIBPRESSIO_HAS_MAGICK=ON \
      -DLIBPRESSIO_HAS_HDF=ON \
      -DBUILD_PYTHON_WRAPPER=ON \
      -G Ninja && \
    cmake --build . && \
    ninja install && \
    CTEST_OUTPUT_ON_FAILURE=1 ctest .



FROM ubuntu:18.04
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y zlib1g libfftw3-dev libhdf5-dev libzstd-dev python3-numpy libstdc++-7-dev libpython3.6 libmagick++-6.q16-7 libblosc1 && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /usr/local/lib/libSZ.so* \
                    /usr/local/lib/liblibpressio.so* \
                    /usr/local/lib/libzfp.so*  \
                    /usr/local/lib/libmgard.so* \
                    /usr/local/lib/fpzip.so* \
                    /usr/local/lib/
COPY --from=builder /usr/local/include/libpressio \
                    /usr/local/include/sz \
                    /usr/local/include/zfp* \
                    /usr/local/include/mgard* \
                    /usr/local/include/fpzip* \
                    /usr/local/include/
COPY --from=builder /usr/local/bin/sz /usr/bin/
COPY --from=builder /usr/lib/python3/dist-packages/*pressio* /usr/lib/python3/dist-packages/
RUN ldconfig


