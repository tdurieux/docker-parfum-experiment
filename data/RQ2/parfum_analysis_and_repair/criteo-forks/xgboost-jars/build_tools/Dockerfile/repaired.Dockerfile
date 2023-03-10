FROM centos:6

ENV DEVTOOLSET_URL_ROOT http://vault.centos.org/6.9/sclo/x86_64/rh/devtoolset-4/

# Install all basic requirements
RUN \
    yum -y update && \
    yum install -y tar unzip wget xz git centos-release-scl yum-utils java-1.8.0-openjdk-devel && \
    yum-config-manager --enable centos-sclo-rh-testing && \
    yum -y update && \
    yum install -y $DEVTOOLSET_URL_ROOT/devtoolset-4-gcc-5.3.1-6.1.el6.x86_64.rpm \
    $DEVTOOLSET_URL_ROOT/devtoolset-4-gcc-c++-5.3.1-6.1.el6.x86_64.rpm \
    $DEVTOOLSET_URL_ROOT/devtoolset-4-binutils-2.25.1-8.el6.x86_64.rpm \
    $DEVTOOLSET_URL_ROOT/devtoolset-4-runtime-4.1-3.sc1.el6.x86_64.rpm \
    $DEVTOOLSET_URL_ROOT/devtoolset-4-libstdc++-devel-5.3.1-6.1.el6.x86_64.rpm && \
    # Python
    wget -O Miniconda3.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3.sh -b -p /opt/python && \
    # CMake
    wget -nv -nc https://cmake.org/files/v3.13/cmake-3.13.0-Linux-x86_64.sh --no-check-certificate && \
    bash cmake-3.13.0-Linux-x86_64.sh --skip-license --prefix=/usr && \
    # Maven
    wget https://archive.apache.org/dist/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz && \
    tar xvf apache-maven-3.6.1-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.6.1/ /opt/maven && rm -rf /var/cache/yum

ENV PATH=/opt/python/bin:/opt/maven/bin:$PATH
ENV CC=/opt/rh/devtoolset-4/root/usr/bin/gcc
ENV CXX=/opt/rh/devtoolset-4/root/usr/bin/c++
ENV CPP=/opt/rh/devtoolset-4/root/usr/bin/cpp
ENV JAVA_HOME=/usr/lib/jvm/java

# Install Python packages
RUN \
    pip install --no-cache-dir numpy pytest scipy scikit-learn wheel kubernetes urllib3==1.22 awscli

COPY build.sh build.sh
COPY launch.sh launch.sh

WORKDIR /xgboost

