FROM ubuntu:18.04
LABEL author="James Cherry"
LABEL maintainer="James Cherry <cherry@parallaxsw.com>"

# install basics
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install --no-install-recommends -y wget apt-utils git cmake gcc tcl-dev swig bison flex && rm -rf /var/lib/apt/lists/*;

# download CUDD
RUN wget https://www.davidkebo.com/source/cudd_versions/cudd-3.0.0.tar.gz && \
    tar -xvf cudd-3.0.0.tar.gz && \
    rm cudd-3.0.0.tar.gz

# install CUDD
RUN cd cudd-3.0.0 && \
    mkdir ../cudd && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$HOME/cudd && \
    make && \
    make install

# copy files and install OpenSTA
RUN mkdir OpenSTA
COPY . OpenSTA
RUN cd OpenSTA && \
    mkdir build && \
    cd build && \
    cmake .. -DCUDD=$HOME/cudd && \
    make

# Run sta on entry
ENTRYPOINT ["OpenSTA/app/sta"]
