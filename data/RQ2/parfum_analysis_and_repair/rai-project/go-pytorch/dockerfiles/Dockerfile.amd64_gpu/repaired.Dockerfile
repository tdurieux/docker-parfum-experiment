FROM carml/base:amd64-gpu-latest
MAINTAINER Abdul Dakkak <dakkak@illinois.edu>

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG VERSION
ARG ARCH
ARG FRAMEWORK_VERSION
LABEL org.carml.go-pytorch.build-date=$BUILD_DATE \
  org.carml.go-pytorch.name="go-pytorch bindings for go" \
  org.carml.go-pytorch.description="" \
  org.carml.go-pytorch.url="https://www.mlmodelscope.org/" \
  org.carml.go-pytorch.vcs-ref=$VCS_REF \
  org.carml.go-pytorch.vcs-url=$VCS_URL \
  org.carml.go-pytorch.vendor="MLModelScope" \
  org.carml.go-pytorch.arch=$ARCH \
  org.carml.go-pytorch.version=$VERSION \
  org.carml.go-pytorch.framework_version=$FRAMEWORK_VERSION \
  org.carml.go-pytorch.schema-version="1.0"

########## DEPENDENCIES INSTALLATION ###################
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
  libgoogle-glog-dev \
  libboost-all-dev \
  libgtest-dev \
  libprotobuf-dev \
  protobuf-compiler \
  libgflags-dev \
  libiomp-dev \
  libleveldb-dev \
  liblmdb-dev \
  libopencv-dev \
  libopenmpi-dev \
  libsnappy-dev \
  openmpi-bin \
  openmpi-doc \
  libeigen3-dev \
  python-dev \
  python-pip \
  python-setuptools \
  python-yaml \
  tzdata && \
  rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir numpy &&\
  pip install --no-cache-dir typing

RUN ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime && \
  dpkg-reconfigure --frontend noninteractive tzdata

########## LIBRARY INSTALLATION ###################
WORKDIR /opt

RUN apt-get update && apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*


# SOURCE INSTALLATION
ENV PYTORCH_DIST_DIR /opt/libtorch
ARG BRANCH=v1.3.0

RUN git clone --single-branch --depth=1 --recurse-submodules --branch=${BRANCH} https://github.com/pytorch/pytorch.git && cd pytorch && \
  git submodule update --init && \
  mkdir build && cd build && \
  cmake .. \
  -DCMAKE_INSTALL_PREFIX=$PYTORCH_DIST_DIR \
  -DBUILD_TORCH=ON \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_CXX11_ABI=1" \
  -DUSE_OBSERVERS=ON \
  -DUSE_PROF=ON \
  -DBLAS=OpenBLAS \
  -DBUILD_CUSTOM_PROTOBUF=OFF \
  -DBUILD_PYTHON=ON \
  -DUSE_NATIVE_ARCH=ON \
  -DUSE_NNPACK=ON \
  -DUSE_OPENCV=OFF \
  -DUSE_MKL=OFF \
  -DUSE_DISTRIBUTED=OFF \
  -DUSE_ROCKSDB=OFF \
  -DUSE_GLOO=OFF \
  -DUSE_NCCL=OFF \
  -DUSE_CUDA=ON \
  -DUSE_CUDNN=ON \
  -DCUDA_ARCH_NAME=Manual \
  -DTORCH_CUDA_ARCH_LIST="3.5 5.0 5.2 6.0 6.1 7.0 7.5+PTX" \
  -DPYTORCH_CUDA_ARCH_LIST="3.5 5.0 5.2 6.0 6.1 7.0 7.5+PTX" \
  && make install \
  && ldconfig \
  && make clean \
  && cd .. \
  && rm -rf build

### Built-in method to build custom libtorch
#RUN git clone --single-branch --depth=1 --recurse-submodules --branch=$FRAMEWORK_VERSION  https://github.com/pytorch/pytorch.git && cd pytorch && \
#  git submodule update --init && \
#  cd tools && \
#  ls -l && \
#  python build_libtorch.py

RUN echo "$PYTORCH_DIST_DIR/lib" >> /etc/ld.so.conf.d/libtorch.conf && ldconfig
ENV LD_LIBRARY_PATH /opt/libtorch/lib:${LD_LIBRARY_PATH}

########## GO BINDING INSTALLATION ###################
ENV PKG github.com/rai-project/go-pytorch
WORKDIR $GOPATH/src/$PKG

RUN git clone --depth=1 --single-branch --branch=master https://${PKG}.git .

RUN dep ensure -v -no-vendor -update \
    github.com/rai-project/dlframework && \
    dep ensure -v -vendor-only

RUN go install -a -installsuffix cgo -ldflags "-s -w -X ${PKG}/Version=${VERSION} -X ${PKG}/GitCommit=${VCS_REF} -X ${PKG}/BuildDate=${BUILD_DATE}"&& \
  rm -fr vendor
