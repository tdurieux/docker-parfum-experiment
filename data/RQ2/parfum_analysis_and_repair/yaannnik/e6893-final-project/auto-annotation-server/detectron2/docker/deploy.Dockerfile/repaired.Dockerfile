# Copyright (c) Facebook, Inc. and its affiliates.
# This file defines a container that compiles the C++ examples of detectron2.
# See docker/README.md for usage.

# Depends on the image produced by "./Dockerfile"
FROM detectron2:v0

USER appuser
ENV HOME=/home/appuser
WORKDIR $HOME

# Let torchvision find libtorch
ENV CMAKE_PREFIX_PATH=$HOME/.local/lib/python3.6/site-packages/torch/

RUN sudo apt-get update && sudo apt-get install --no-install-recommends libgflags-dev libgoogle-glog-dev libopencv-dev --yes && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir mkl-include

# Install the correct version of protobuf (find it at torch/caffe2/proto/caffe2.pb.h after installing pytorch):
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.13.0/protobuf-cpp-3.13.0.tar.gz && tar xf protobuf-cpp-3.13.0.tar.gz && rm protobuf-cpp-3.13.0.tar.gz
RUN export CXXFLAGS=-D_GLIBCXX_USE_CXX11_ABI=$(python3 -c 'import torch; print(int(torch.compiled_with_cxx11_abi()))'); \
	cd protobuf-3.13.0 && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$HOME/.local && make -j && make install

# install libtorchvision
RUN git clone --branch v0.11.1 https://github.com/pytorch/vision/
RUN mkdir vision/build && cd vision/build && \
	cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Release -DWITH_CUDA=on -DTORCH_CUDA_ARCH_LIST=$TORCH_CUDA_ARCH_LIST && \
	make -j && make install

# make our installation take effect
ENV CPATH=$HOME/.local/include \
	  LIBRARY_PATH=$HOME/.local/lib \
	  LD_LIBRARY_PATH=$HOME/.local/lib


# build C++ examples of detectron2
RUN cd detectron2_repo/tools/deploy && mkdir build && cd build && \
	 cmake -DTORCH_CUDA_ARCH_LIST=$TORCH_CUDA_ARCH_LIST .. && make
# binaries will be available under tools/deploy/build
