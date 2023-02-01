FROM centos:centos7

# install base dependencies and supported compilers
RUN yum install -y bzip2 gcc-c++ pcre-devel wget && \
    yum install -y bison flex && \
    yum install -y centos-release-scl && \
    yum install -y devtoolset-8 devtoolset-8-libatomic-devel && \
    yum install -y llvm-toolset-7.0 llvm-toolset-7.0-libomp-devel && \
    yum install -y tcl zlib-static && rm -rf /var/cache/yum

# install swig
RUN wget https://prdownloads.sourceforge.net/swig/swig-4.0.0.tar.gz && \
    tar -xf swig-4.0.0.tar.gz && \
    cd swig-4.0.0 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make -j$(nproc) && \
    make install && rm swig-4.0.0.tar.gz

# install cmake
RUN wget https://cmake.org/files/v3.14/cmake-3.14.0-Linux-x86_64.sh && \
    chmod +x cmake-3.14.0-Linux-x86_64.sh  && \
    ./cmake-3.14.0-Linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm -rf cmake-3.14.0-Linux-x86_64.sh

# install boost
RUN wget https://sourceforge.net/projects/boost/files/boost/1.72.0/boost_1_72_0.tar.bz2/download && \
    tar -xf download && \
    cd boost_1_72_0 && \
    ./bootstrap.sh && \
    ./b2 install --with-iostreams --with-test link=shared -j $(nproc)

COPY .  /TritonRoute
WORKDIR /TritonRoute

# set compiiler (gcc is default), to change to clang use
# docker build --build-arg compiler=clang7 [...]
ARG compiler=gcc8
RUN ./jenkins/build_centos7_$compiler.sh
