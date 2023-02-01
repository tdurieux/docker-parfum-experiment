FROM ubuntu:14.04

# Deps of eigen, dynet and modlm
RUN apt-get update && apt-get install --no-install-recommends -y vim git mercurial && \
    apt-get install --no-install-recommends -y build-essential cmake && \
    apt-get install --no-install-recommends -y libtool autotools-dev libboost1.54-all-dev autoconf bc && rm -rf /var/lib/apt/lists/*;

ENV PROJECT_DIR /scratch/modlm_project
RUN mkdir -p $PROJECT_DIR && \
    useradd -ms /bin/bash ubuntu && \
    chown -R ubuntu:ubuntu $PROJECT_DIR

USER ubuntu
WORKDIR $PROJECT_DIR

# Download the code
RUN hg clone https://bitbucket.org/eigen/eigen/ -r 346ecdb && \
    git clone https://github.com/clab/dynet && \
    git clone https://github.com/alancucki/modlm.git

# Compile dynet
RUN cd dynet && git checkout tags/v2.0 && \
    mkdir build && cd build && \
    cmake .. -DEIGEN3_INCLUDE_DIR=$PROJECT_DIR/eigen/ -DENABLE_CPP_EXAMPLES=ON && \
    make -j 4

ENV LD_LIBRARY_PATH $PROJECT_DIR/dynet/build/dynet:$LD_LIBRARY_PATH

# Compile modlm
RUN cd modlm && \
    autoreconf -i && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-dynet=$PROJECT_DIR/dynet --with-eigen=$PROJECT_DIR/eigen && \
    make -j 4

WORKDIR $PROJECT_DIR/modlm
