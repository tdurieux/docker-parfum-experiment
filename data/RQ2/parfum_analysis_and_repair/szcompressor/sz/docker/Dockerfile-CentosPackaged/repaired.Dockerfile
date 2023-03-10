FROM centos:7
RUN yum update -y && \
    yum install -y epel-release && \ 
    yum install -y \
        cmake3 \
        CUnit-devel \
        ctags \
        gcc \
        gcc-c++ \
        fftw-devel \
        netcdf-devel \
        make \
        swig3 \
        python-devel \
        numpy && \
    yum clean all && rm -rf /var/cache/yum
COPY . /build/
WORKDIR /build/
RUN rm -rf build && \
    mkdir -p build && \
    cd build && \
    cmake3 .. && \
    make -j
