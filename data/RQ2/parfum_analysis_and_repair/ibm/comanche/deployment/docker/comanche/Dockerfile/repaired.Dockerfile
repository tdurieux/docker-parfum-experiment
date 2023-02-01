# ofed4.3-1.0.1.0 as base image. If you don't have this, build it first.
FROM ofed4.3-1.0.1.0
MAINTAINER travis.janssen@ibm.com

WORKDIR /tmp

# get dependencies
RUN apt-get upgrade && \
    apt-get update && \
    apt-get install --no-install-recommends -y git && \
    apt-get install --no-install-recommends -y build-essential && \
    apt-get install --no-install-recommends -y cmake && \
    git clone https://github.com/IBM/comanche.git && rm -rf /var/lib/apt/lists/*;

# set up comanche
WORKDIR comanche
RUN cmake --help
RUN bash deps/install-apts.sh
RUN git submodule update --init --recursive
RUN mkdir build

WORKDIR build
RUN cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX:PATH=`pwd`/dist ..
RUN make bootstrap
RUN make
RUN make install
