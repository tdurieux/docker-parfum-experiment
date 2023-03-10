FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH=/usr/local/lib

RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y git wget curl cmake build-essential git libcos4-dev libomniorb4-dev libomnithread4-dev libzmq3-dev omniidl python3 pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --reinstall ca-certificates && rm -rf /var/lib/apt/lists/*;

# latest cmake
RUN git clone https://github.com/Kitware/CMake cmake
RUN cd cmake && git checkout v3.22.0
RUN mkdir /cmake/build
RUN cd /cmake/build && ../bootstrap && make -j$(nproc) && make install

# libzmq
RUN git clone https://github.com/zeromq/libzmq
RUN cd libzmq && git checkout v4.2.0
RUN mkdir /libzmq/build
RUN cd /libzmq/build && cmake -DENABLE_DRAFTS=OFF -DWITH_DOC=OFF -DZMQ_BUILD_TESTS=OFF .. && make -j$(nproc) && make install

# cppzmq
RUN git clone https://github.com/zeromq/cppzmq
RUN cd cppzmq && git checkout v4.7.1
RUN mkdir /cppzmq/build
RUN cd /cppzmq/build && cmake -DCPPZMQ_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=/usr/local .. && make -j$(nproc) && make install

# Tango IDL
RUN git clone https://gitlab.com/tango-controls/tango-idl
RUN cd tango-idl
RUN mkdir /tango-idl/build
RUN cd /tango-idl/build && cmake .. && make install

# cppTango
RUN git clone https://gitlab.com/tango-controls/cppTango
RUN mkdir /cppTango/build
RUN cd /cppTango/build && cmake .. && make -j$(nproc) && make install

# Install rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y