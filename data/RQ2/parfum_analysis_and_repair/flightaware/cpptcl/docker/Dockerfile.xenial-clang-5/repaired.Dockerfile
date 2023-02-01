FROM ubuntu:xenial

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y wget software-properties-common git && rm -rf /var/lib/apt/lists/*;
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main"
# This may skip archives which is ok, but the return code will be 100
RUN apt-get update -qq || exit 0
RUN apt-get install --no-install-recommends -y clang-5.0 libc++-dev tcl-dev && rm -rf /var/lib/apt/lists/*;

# Build cmake from source
RUN mkdir -p /root/git && cd /root/git && \
    wget https://cmake.org/files/v3.10/cmake-3.10.3.tar.gz && \
    tar -xzf cmake-3.10.3.tar.gz && \
    cd cmake-3.10.3 && ./bootstrap && \
    make && make install && \
    cmake --version && rm cmake-3.10.3.tar.gz

# Build cpptcl with clang++-5.0
RUN cd /root/git && \
    git clone https://github.com/flightaware/cpptcl.git && \
    cd cpptcl && \
    mkdir build && cd build && \
    cmake -DCMAKE_CXX_COMPILER=clang++-5.0 -DCMAKE_C_COMPILER=clang-5.0 .. && \
    make && \
    cd .. && make test
