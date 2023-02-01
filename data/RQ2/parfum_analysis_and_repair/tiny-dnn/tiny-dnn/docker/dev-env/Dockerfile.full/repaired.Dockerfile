FROM ubuntu:17.04

MAINTAINER Edgar Riba <edgar.riba@gmail.com>

# install basic stuff

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential       \
    cmake                 \
    python-pip            \
    python-setuptools     \
    git                   \
    vim && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

# install optional dependencies

RUN apt-get install --no-install-recommends -y \
    libpthread-stubs0-dev \
    libtbb-dev && rm -rf /var/lib/apt/lists/*;

# install linters

RUN apt-get install --no-install-recommends -y \
    clang-format-4.0 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir cpplint

# configure and build NNPACK

RUN apt-get install -y --no-install-recommends ninja-build && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade setuptools && \
    pip install --no-cache-dir wheel && \
    pip install --no-cache-dir ninja-syntax

RUN pip install --no-cache-dir --upgrade git+https://github.com/tiny-dnn/PeachPy
RUN pip install --no-cache-dir --upgrade git+https://github.com/tiny-dnn/confu

WORKDIR /opt
RUN git clone https://github.com/tiny-dnn/NNPACK.git && \
    cd NNPACK && \
    confu setup && \
    python ./configure.py && \
    ninja

# install opencl and viennacl

RUN apt-get install --no-install-recommends -y \
    ocl-icd-opencl-dev \
    libviennacl-dev && rm -rf /var/lib/apt/lists/*;

# build and configure libdnn

WORKDIR /opt
RUN git clone https://github.com/naibaf7/libdnn.git && \
    cd libdnn && mkdir build && cd build && \
    cmake .. && make -j2
