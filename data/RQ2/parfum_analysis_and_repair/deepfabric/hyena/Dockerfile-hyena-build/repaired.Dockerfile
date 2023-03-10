FROM centos/devtoolset-7-toolchain-centos7

USER 0

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm  \
     && yum -y install git \
     && yum -y install scons make openblas-devel swig python-devel numpy glog-devel gflags-devel boost-devel jemalloc-devel \
     && yum -y install go \
     && yum -y install snappy-devel \
     && yum -y install zlib-devel  \
     && yum -y install bzip2-devel \
     && yum -y install epel-release \
     && yum -y install jemalloc-devel \
     && yum -y install gtest-devel \
     && yum group -y install "Development Tools" && rm -rf /var/cache/yum