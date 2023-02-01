FROM ubuntu:19.10

RUN apt update -y && apt install --no-install-recommends -y cmake gcc-9 g++-9 clang-8 autotools-dev autoconf clang-tidy-8 python3-pip && \
    pip3 install --no-cache-dir conan && \
    pip3 install --no-cache-dir gcovr && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp/expresscpp
COPY . /tmp/expresscpp

RUN export CC=/usr/bin/clang-8 && \
    export CXX=/usr/bin/clang++-8 && \
    rm -rf build || true && \
    mkdir -p build && \
    cd build && \
    cmake .. -DEXPRESSCPP_USE_CONAN_DEPENDENCIES=ON && \
    make -j && \
    cd ../ && \
    rm -rf ./build
