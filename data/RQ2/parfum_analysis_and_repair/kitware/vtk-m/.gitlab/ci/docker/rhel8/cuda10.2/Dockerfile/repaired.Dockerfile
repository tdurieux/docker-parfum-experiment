FROM nvidia/cuda:10.2-devel-ubi8
LABEL maintainer "Robert Maynard<robert.maynard@kitware.com>"

RUN yum install make gcc gcc-c++ curl cuda-compat-10-2 -y && rm -rf /var/cache/yum
RUN curl -f -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | bash
RUN yum install git git-lfs -y && rm -rf /var/cache/yum

# Provide CMake 3.17 so we can re-run tests easily
# This will be used when we run just the tests
RUN mkdir /opt/cmake/ && \
    curl -f -L https://github.com/Kitware/CMake/releases/download/v3.17.3/cmake-3.17.3-Linux-x86_64.sh > cmake-3.17.3-Linux-x86_64.sh && \
    sh cmake-3.17.3-Linux-x86_64.sh --prefix=/opt/cmake/ --exclude-subdir --skip-license && \
    rm cmake-3.17.3-Linux-x86_64.sh && \
    ln -s /opt/cmake/bin/ctest /opt/cmake/bin/ctest-latest

ENV PATH "/opt/cmake/bin:${PATH}"
