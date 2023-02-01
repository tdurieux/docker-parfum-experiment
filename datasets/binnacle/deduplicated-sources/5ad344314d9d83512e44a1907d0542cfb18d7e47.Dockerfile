FROM ngraph_test_base

# Caffe2 dependencies
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    g++ \
    libeigen3-dev \
    libgoogle-glog-dev \
    libleveldb-dev \
    liblmdb-dev \
    libopencv-dev \
    libprotobuf-dev \
    libsnappy-dev \
    zlib1g-dev \
    libbz2-dev \
    protobuf-compiler \
    python-dev \
    python-pip

# Required Python packages
RUN pip install --upgrade pip && pip install \
    numpy \
    protobuf

# Supported revision of Caffe2
ENV CAFFE2_CLONE_TAG=master
ENV CAFFE2_REV=51eab3c6554fe99648fa46f43ed854223714472a

# Clone Caffe2
RUN git clone -b ${CAFFE2_CLONE_TAG} https://github.com/caffe2/caffe2.git /opt/caffe2

WORKDIR /opt/caffe2/

# Checkout supported revision
RUN git reset --hard ${CAFFE2_REV}

# Clone only required submodules
RUN git submodule init && \
    git submodule update third_party/benchmark/  && \
    git submodule update third_party/googletest && \
    git submodule update third_party/pybind11 && \
    git submodule update third_party/eigen

# Build Caffe2
RUN mkdir build && cd build && \
    cmake .. -DUSE_ROCKSDB=OFF -DUSE_MPI=OFF -DUSE_OPENMP=OFF -DUSE_CUDA=OFF \
             -DCMAKE_INSTALL_PREFIX=`pwd`/install  && \
    make -j$(nproc) && make install

# Set path to the Python modules required by Caffe2 Frontend
ENV PYTHONPATH=/opt/caffe2/build/:$PYTHONPATH
WORKDIR /root/ngraph-test

# necessary for tests/test_walkthrough.py which requires that ngraph is
# importable from an entrypoint not local to ngraph.
ADD . /root/ngraph-test
RUN pip install -e .
