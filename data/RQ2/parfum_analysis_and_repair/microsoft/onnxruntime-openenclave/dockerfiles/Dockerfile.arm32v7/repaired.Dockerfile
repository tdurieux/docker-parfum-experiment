FROM balenalib/raspberrypi3-python:latest-stretch-build

ARG ONNXRUNTIME_REPO=https://github.com/Microsoft/onnxruntime
ARG ONNXRUNTIME_SERVER_BRANCH=master

#Enforces cross-compilation through Quemu
RUN [ "cross-build-start" ]

RUN install_packages \
    sudo \
    build-essential \
    curl \
    libcurl4-openssl-dev \
    libssl-dev \
    wget \
    python3 \
    python3-pip \
    python3-dev \
    git \
    tar \
    libatlas-base-dev

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade setuptools
RUN pip3 install --no-cache-dir --upgrade wheel
RUN pip3 install --no-cache-dir numpy

# Build the latest cmake
WORKDIR /code
RUN wget https://github.com/Kitware/CMake/releases/download/v3.14.3/cmake-3.14.3.tar.gz
RUN tar zxf cmake-3.14.3.tar.gz && rm cmake-3.14.3.tar.gz

WORKDIR /code/cmake-3.14.3
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --system-curl
RUN make
RUN sudo make install

# Set up build args
ARG BUILDTYPE=MinSizeRel
ARG BUILDARGS="--config ${BUILDTYPE} --arm"

# Prepare onnxruntime Repo
WORKDIR /code
RUN git clone --single-branch --branch ${ONNXRUNTIME_SERVER_BRANCH} --recursive ${ONNXRUNTIME_REPO} onnxruntime

# Start the basic build
WORKDIR /code/onnxruntime
RUN ./build.sh --use_openmp ${BUILDARGS} --update --build

# Build Shared Library
RUN ./build.sh --use_openmp ${BUILDARGS} --build_shared_lib

# Build Python Bindings and Wheel
RUN ./build.sh --use_openmp ${BUILDARGS} --enable_pybind --build_wheel

# Build Output
RUN ls -l /code/onnxruntime/build/Linux/${BUILDTYPE}/*.so
RUN ls -l /code/onnxruntime/build/Linux/${BUILDTYPE}/dist/*.whl

RUN [ "cross-build-end" ]
