FROM ubuntu:16.04

RUN apt-get -y update

# nGraph dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  cmake \
  clang-3.9 \
  git \
  curl \
  zlib1g \
  zlib1g-dev \
  libtinfo-dev \
  unzip \
  autoconf \
  automake \
  libtool && \
  apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

# Python dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
  python3 \
  python3-dev \
  python3-pip \
  python-virtualenv && \
  apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel

# ONNX dependencies
RUN apt-get -y --no-install-recommends install protobuf-compiler libprotobuf-dev && rm -rf /var/lib/apt/lists/*;

# Install nGraph in /root/ngraph
WORKDIR /root
RUN git clone https://github.com/NervanaSystems/ngraph.git
RUN mkdir /root/ngraph/build
WORKDIR /root/ngraph/build
RUN cmake ../ -DNGRAPH_CPU_ENABLE=FALSE -DNGRAPH_USE_PREBUILT_LLVM=TRUE -DNGRAPH_ONNX_IMPORT_ENABLE=TRUE -DCMAKE_INSTALL_PREFIX=/root/ngraph_dist
RUN make -j"$(nproc)"
RUN make install

# Build nGraph Wheel
WORKDIR /root/ngraph/python
RUN git clone --recursive https://github.com/pybind/pybind11.git
ENV NGRAPH_ONNX_IMPORT_ENABLE TRUE
ENV PYBIND_HEADERS_PATH /root/ngraph/python/pybind11
ENV NGRAPH_CPP_BUILD_PATH /root/ngraph_dist
RUN python3 setup.py bdist_wheel

# Test nGraph-ONNX
COPY . /root/ngraph-onnx
WORKDIR /root/ngraph-onnx
RUN pip install --no-cache-dir tox
CMD NGRAPH_BACKEND=INTERPRETER TOX_INSTALL_NGRAPH_FROM=`find /root/ngraph/python/dist/ -name 'ngraph*.whl'` tox
