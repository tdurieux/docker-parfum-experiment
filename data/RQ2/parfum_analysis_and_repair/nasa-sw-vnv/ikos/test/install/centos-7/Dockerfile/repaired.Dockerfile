FROM centos:7
MAINTAINER Maxime Arthaud <maxime.arthaud@nasa.gov>
ARG njobs=2
ARG build_type=Release

# Installs the following versions (note that it might be out of date):
# cmake 3.15.2
# gmp 6.0.0
# mpfr 3.1.1
# ppl 1.2
# apron 0.9.10
# boost 1.70.0
# python 2.7.5
# sqlite 3.7.17
# tbb 6103
# llvm 9.0.0
# clang 9.0.0
# gcc 8.3.1

# Upgrade
RUN yum -y update

# Install dependencies using CentOS Sofware Collections Repository
RUN yum -y install which patch bzip2 xz zlib-devel libedit-devel make m4 gmp-devel mpfr-devel python python-pygments sqlite-devel tbb-devel && rm -rf /var/cache/yum
RUN yum -y install centos-release-scl && rm -rf /var/cache/yum
RUN yum -y install devtoolset-8-gcc devtoolset-8-gcc-c++ && rm -rf /var/cache/yum

# Update env to use devtoolset-8
ENV PATH "/opt/rh/devtoolset-8/root/usr/bin:$PATH"
ENV LD_LIBRARY_PATH "/opt/rh/devtoolset-8/root/usr/lib64:/opt/rh/devtoolset-8/root/usr/lib"

# Add ikos source code
ADD . /root/ikos

# Use the bootstrap script to install ikos and run the tests
WORKDIR /root/ikos/script
RUN ./bootstrap -vvf \
        --prefix="/opt/ikos" \
        --builddir="/root/ikos-build" \
        --build-type="$build_type" \
        --jobs="$njobs"

# Done
WORKDIR /
