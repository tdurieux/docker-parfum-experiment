FROM ubuntu:18.04

ARG CXX_COMPILER=g++-7

RUN apt-get -y update && \
    apt-get -y install clang git build-essential \
    wget curl autoconf libtool cmake

# Build GTIRB
COPY . /gt/gtirb/
RUN rm -rf /gt/gtirb/build /gt/gtirb/CMakeCache.txt /gt/gtirb/CMakeFiles /gt/gtirb/CMakeScripts
RUN mkdir -p /gt/gtirb/build
WORKDIR /gt/gtirb/build
RUN cmake ../ -DCMAKE_CXX_COMPILER=${CXX_COMPILER}
RUN make -j

WORKDIR /gt/gtirb/
ENV PATH=/gt/gtirb/build/bin:$PATH
