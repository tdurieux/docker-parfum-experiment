FROM nvidia/cuda:9.0-devel-centos7

# MKL
RUN mkdir -p /opt/intel/lib
COPY mkl_libs/libmkl_core.a /opt/intel/lib/libmkl_core.a
COPY mkl_libs/libmkl_gnu_thread.a /opt/intel/lib/libmkl_gnu_thread.a
COPY mkl_libs/libmkl_intel_lp64.a /opt/intel/lib/libmkl_intel_lp64.a
COPY mkl_libs/include /opt/intel/

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN yum install -y wget curl perl util-linux xz bzip2 git patch which perl
RUN yum install -y yum-utils centos-release-scl
RUN yum-config-manager --enable rhel-server-rhscl-7-rpms
RUN yum install -y devtoolset-3-gcc devtoolset-3-gcc-c++ devtoolset-3-gcc-gfortran devtoolset-3-binutils
ENV PATH=/opt/rh/devtoolset-3/root/usr/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/rh/devtoolset-3/root/usr/lib64:/opt/rh/devtoolset-3/root/usr/lib:$LD_LIBRARY_PATH

# EPEL for cmake
RUN wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    rpm -ivh epel-release-latest-7.noarch.rpm && \
    rm -f epel-release-latest-7.noarch.rpm

# cmake
RUN yum install -y cmake3 && \
    ln -s /usr/bin/cmake3 /usr/bin/cmake

# build python
COPY build_scripts /build_scripts
RUN bash build_scripts/build.sh && rm -r build_scripts

ENV SSL_CERT_FILE=/opt/_internal/certs.pem

# remove unncessary python versions
RUN rm -rf /opt/python/cp26-cp26m /opt/_internal/cpython-2.6.9-ucs2
RUN rm -rf /opt/python/cp26-cp26mu /opt/_internal/cpython-2.6.9-ucs4
RUN rm -rf /opt/python/cp33-cp33m /opt/_internal/cpython-3.3.6
RUN rm -rf /opt/python/cp34-cp34m /opt/_internal/cpython-3.4.6

# install CUDA 9.0 in the same container
RUN wget -q https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run && \
    chmod +x cuda_9.0.176_384.81_linux-run && \
    ./cuda_9.0.176_384.81_linux-run --silent --no-opengl-libs --toolkit && \
    rm -f cuda_9.0.176_384.81_linux-run

# patch 1, patch2
RUN wget -q https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/1/cuda_9.0.176.1_linux-run && \
    chmod +x cuda_9.0.176.1_linux-run && \
    ./cuda_9.0.176.1_linux-run -s --accept-eula && \
    rm -f cuda_9.0.176.1_linux-run
RUN wget -q https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/2/cuda_9.0.176.2_linux-run && \
    chmod +x cuda_9.0.176.2_linux-run && \
    ./cuda_9.0.176.2_linux-run -s --accept-eula && \
    rm -f cuda_9.0.176.2_linux-run

# install CUDA 9.0 CuDNN
# cuDNN license: https://developer.nvidia.com/cudnn/license_agreement
RUN mkdir tmp_cudnn && cd tmp_cudnn && \
    wget -q http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7-dev_7.5.1.10-1+cuda9.0_amd64.deb && \
    wget -q http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7_7.5.1.10-1+cuda9.0_amd64.deb && \
    ar -x libcudnn7-dev_7.5.1.10-1+cuda9.0_amd64.deb && tar -xvf data.tar.xz && \
    ar -x libcudnn7_7.5.1.10-1+cuda9.0_amd64.deb && tar -xvf data.tar.xz && \
    mkdir -p cuda/include && mkdir -p cuda/lib64 && \
    cp -a usr/include/x86_64-linux-gnu/cudnn_v7.h cuda/include/cudnn.h && \
    cp -a usr/lib/x86_64-linux-gnu/libcudnn* cuda/lib64 && \
    mv cuda/lib64/libcudnn_static_v7.a cuda/lib64/libcudnn_static.a && \
    ln -s libcudnn.so.7 cuda/lib64/libcudnn.so && \
    chmod +x cuda/lib64/*.so && \
    cp -a cuda/include/* /usr/local/cuda/include/ && \
    cp -a cuda/lib64/* /usr/local/cuda/lib64/ && \
    cd .. && \
    rm -rf tmp_cudnn && \
    ldconfig

# magma
RUN wget http://icl.cs.utk.edu/projectsfiles/magma/downloads/magma-2.5.0.tar.gz && \
    tar -xvf magma-2.5.0.tar.gz && \
    cd magma-2.5.0 && \
    wget https://raw.githubusercontent.com/pytorch/builder/master/conda/magma-cuda90-2.5.0/cmakelists.patch && \
    wget https://raw.githubusercontent.com/pytorch/builder/master/conda/magma-cuda90-2.5.0/thread_queue.patch && \
    wget https://raw.githubusercontent.com/pytorch/builder/master/conda/magma-cuda90-2.5.0/xhsgetrf_gpu.patch && \
    patch <cmakelists.patch && \
    patch -p0 <thread_queue.patch && \
    patch -p0 <xhsgetrf_gpu.patch && \
    mkdir build && \
    cd build && \
    cmake .. -DUSE_FORTRAN=OFF -DGPU_TARGET="All" -DCMAKE_INSTALL_PREFIX=$PREFIX && \
    make -j$(getconf _NPROCESSORS_CONF) && \
    make install && \
    cd ..

RUN rm -f /usr/local/bin/patchelf
RUN git clone https://github.com/NixOS/patchelf && \
    cd patchelf && \
    sed -i 's/serial/parallel/g' configure.ac && \
    ./bootstrap.sh && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf patchelf

#####################################################################################
# CUDA 9.0 prune static libs
#####################################################################################
ARG NVPRUNE="/usr/local/cuda-9.0/bin/nvprune"
ARG CUDA_LIB_DIR="/usr/local/cuda-9.0/lib64"

ARG GENCODE="-gencode arch=compute_35,code=sm_35 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_60,code=sm_60 -gencode arch=compute_70,code=sm_70"
ARG GENCODE_CUDNN="-gencode arch=compute_35,code=sm_35 -gencode arch=compute_37,code=sm_37 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_60,code=sm_60 -gencode arch=compute_61,code=sm_61 -gencode arch=compute_70,code=sm_70"

# all CUDA libs except CuDNN and CuBLAS (cudnn and cublas need arch 3.7 included)
RUN ls $CUDA_LIB_DIR/ | grep "\.a" | grep -v "culibos" | grep -v "cudart" | grep -v "cudnn" | grep -v "cublas" \
    | xargs -I {} bash -c \
    "echo {} && $NVPRUNE $GENCODE $CUDA_LIB_DIR/{} -o $CUDA_LIB_DIR/{}"

# prune CuDNN and CuBLAS
RUN $NVPRUNE $GENCODE_CUDNN $CUDA_LIB_DIR/libcudnn_static.a -o $CUDA_LIB_DIR/libcudnn_static.a
RUN $NVPRUNE $GENCODE_CUDNN $CUDA_LIB_DIR/libcublas_static.a -o $CUDA_LIB_DIR/libcublas_static.a
RUN $NVPRUNE $GENCODE_CUDNN $CUDA_LIB_DIR/libcublas_device.a -o $CUDA_LIB_DIR/libcublas_device.a
