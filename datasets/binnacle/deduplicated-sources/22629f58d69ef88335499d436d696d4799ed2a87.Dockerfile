FROM centos:7

MAINTAINER Jarle Aase <jgaa@jgaa.com>

RUN echo "root:password" | chpasswd

# We need to create a valid user on the same uid that jenkins use on the host machine.
# Else, we run into failing commands because the current user cannot be resolved.
RUN useradd -u 111 -m -d /home/jenkins -s /bin/bash jenkins
RUN echo "jenkins:jenkins" | chpasswd

RUN yum -y update &&\
    yum -y install centos-release-scl &&\
    yum -y install git jre-openjdk zlib-devel openssl-devel openssh-server bzip2 which make &&\
    yum -y update &&\
    yum -y install devtoolset-7-gcc*
    
# Install cmake > verssion 3.0
RUN mkdir -p /opt/cmake &&\
    curl -L -o cmake.sh https://github.com/Kitware/CMake/releases/download/v3.12.4/cmake-3.12.4-Linux-x86_64.sh &&\
    chmod +x cmake.sh &&\
    ./cmake.sh --skip-license --prefix=/opt/cmake --exclude-subdir
    
ENV PATH="/opt/cmake/bin:${PATH}"

# Build boost and install to /opt/boost
# Note: I skip some large boost libraries that is not used in the target-project
RUN mkdir boost &&\
    cd boost &&\
    curl -o boost.tar.bz2 -L https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.bz2 &&\
    tar -xjf boost.tar.bz2 &&\
    source scl_source enable devtoolset-7 &&\
    cd boost_1_* &&\
    ./bootstrap.sh --prefix=/opt/boost &&\
    ./b2 install --prefix=/opt/boost --without-python --without-wave --without-graph --without-mpi --without-test -j8 &&\
    cd && rm -rf boost

# expose the ssh port
EXPOSE 22

# entrypoint by starting sshd
CMD ["/usr/sbin/sshd", "-D"]

# We need "scl enable devtoolset-7 bash" or "source scl_source enable devtoolset-7" in the build-script
