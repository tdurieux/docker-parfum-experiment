# starting docker is a recent ubuntu
FROM ubuntu:bionic

# install additional packages for development
# cmake, g++, make, git
RUN apt-get update && apt-get install --no-install-recommends -y cmake g++ make git && rm -rf /var/lib/apt/lists/*;

# working directory inside docker, automatically created
WORKDIR /usr/src/morphstore

# volume for shared access to morphstore directory on the host system
VOLUME /morphstore

# copy morphstore directory into docker to WORKDIR
COPY . /usr/src/morphstore

# DELETE build directory - cleanup
RUN rm -r build/

# build morphstore
RUN ./build.sh -rel -j1

# execute a test case
RUN build/test/core/operators/join_test
