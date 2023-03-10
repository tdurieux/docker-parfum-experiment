FROM nvidia/cuda:11.2.0-cudnn8-devel-ubuntu20.04 as builder

ARG TRANSFORMERS_VERSION=4.5.0
ARG PYTORCH_VERSION=1.8.1
ARG TENSORFLOW_VERSION=2.4.1
ARG MKL_THREADING_LIBRARY=OMP
ARG CUDA_ARCH_LIST=7.0;7.5;8.0;8.6+PTX

# Ensure tzdata is set
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && \
    apt install --no-install-recommends -y \
        curl \
        cmake \
        make \
        ninja-build \
        git \
        gpg-agent \
        wget \
        python3 \
        python3-dev \
        python3-pip && rm -rf /var/lib/apt/lists/*;

# Install oneAPI repo
RUN wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB && \
    apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB && \
    rm GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB && \
    echo "deb https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list

RUN apt update && apt install --no-install-recommends -y \
    intel-oneapi-mkl-devel \
    intel-oneapi-runtime-openmp && \
    rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH='/opt/intel/oneapi/tbb/latest/env/lib/intel64/gcc4.8:/opt/intel/oneapi/mkl/latest/lib/intel64'
ENV LIBRARY_PATH='/opt/intel/oneapi/tbb/latest/lib/intel64/gcc4.8:/opt/intel/oneapi/mkl/latest/lib/intel64'
ENV MKLROOT='/opt/intel/oneapi/mkl/latest'

# Create a folder to store all the compiled binaries
ENV FRAMEWORK_BINARIES_FOLDER /opt/bin
RUN mkdir ${FRAMEWORK_BINARIES_FOLDER}

# Bazel for TensorFlow
ENV BAZEL_VERSION 4.0.0
RUN cd "/usr/bin" && curl -fLO https://releases.bazel.build/${BAZEL_VERSION}/release/bazel-${BAZEL_VERSION}-linux-x86_64 && \
    chmod +x bazel-${BAZEL_VERSION}-linux-x86_64 && \
    mv bazel-${BAZEL_VERSION}-linux-x86_64 bazel && \
    ln -s /usr/bin/python3 /usr/bin/python

# Enable MKL to be found by the compilation process
ENV PATH=/opt/intel/oneapi/mkl/latest/include:$PATH
ENV CMAKE_PREFIX_PATH=/opt/intel/oneapi/mkl/latest/lib/intel64:$CMAKE_PREFIX_PATH
ENV CMAKE_INCLUDE_PATH=/opt/intel/oneapi/mkl/latest/include:$PATH:$CMAKE_INCLUDE_PATH

# TODO: Merge with above when ready
ENV BUILD_CAFFE2_OPS=OFF \
    BUILD_CAFFE2=OFF \
    BUILD_TEST=OFF \
    USE_CUDA=ON \
    USE_OPENCV=OFF \
    USE_FFMPEG=OFF \
    USE_LEVELDB=OFF \
    USE_KINETO=OFF \
    USE_REDIS=OFF \
    USE_DISTRIBUTED=OFF \
    USE_QNNPACK=ON \
    USE_FBGEMM=ON \
    USE_NNPACK=ON \
    USE_MKLDNN=ON \
    BLAS=MKL \
    MKLDNN_CPU_RUNTIME=$MKL_THREADING_LIBRARY \
    TORCH_CUDA_ARCH_LIST=$CUDA_ARCH_LIST

# PyTorch
RUN git clone https://github.com/pytorch/pytorch /opt/pytorch && \
    cd /opt/pytorch && \
    git checkout v${PYTORCH_VERSION} && \
    git submodule update --init --recursive && \
    python3 -m pip install -r requirements.txt && \
    python3 setup.py bdist_wheel && \
    ls dist/ | grep -i ".whl" | xargs -I % sh -c 'cp /opt/pytorch/dist/% ${FRAMEWORK_BINARIES_FOLDER}/'



# TensorFlow
RUN git clone https://github.com/tensorflow/tensorflow /opt/tensorflow && \
    cd /opt/tensorflow && \
    git checkout v${TENSORFLOW_VERSION}

COPY docker/.tf_configure.bazelrc /opt/tensorflow/.tf_configure.bazelrc
RUN cd /opt/tensorflow && \
    python3 -m pip install -U --user pip numpy wheel && \
    python3 -m pip install -U --user keras_preprocessing --no-deps && \
    bazel build \
    --config=cuda \
    --config=v2 \
    --config=opt \
    --config=mkl \
    --config=numa \
    --config=noaws \
    --config=nogcp \
    --config=nohdfs \
    --config=nonccl \
    //tensorflow/tools/pip_package:build_pip_package

RUN cd /opt/tensorflow && \
    ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg && \
    ls /tmp/tensorflow_pkg | grep -i ".whl" | xargs -I % sh -c 'cp /tmp/tensorflow_pkg/% ${FRAMEWORK_BINARIES_FOLDER}/'


# ONNX Runtime
RUN git clone https://github.com/microsoft/onnxruntime opt/onnxruntime && \
    cd /opt/onnxruntime && \
    ./build.sh --config=Release --parallel --cmake_generator=Ninja --enable_pybind --build_wheel --enable_lto --use_openmp --skip_tests --skip_onnx_tests && \
    ls /opt/onnxruntime/build/Linux/Release/dist/ | grep -i ".whl" | xargs -I % sh -c 'cp /opt/onnxruntime/build/Linux/Release/dist/% ${FRAMEWORK_BINARIES_FOLDER}/'

FROM nvidia/cuda:11.2.0-cudnn8-runtime-ubuntu20.04

RUN apt update && \
    apt install --no-install-recommends -y \
          python3 \
          python3-pip \
          numactl \
          libtcmalloc-minimal4 \
          wget && rm -rf /var/lib/apt/lists/*;

# Install oneAPI repo
RUN wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB && \
    apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB && \
    rm GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB && \
    echo "deb https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list

RUN apt update && apt install --no-install-recommends -y \
    intel-oneapi-mkl \
    intel-oneapi-runtime-openmp && \
    rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH='/usr/local/cuda/compat:/opt/intel/oneapi/tbb/latest/env/lib/intel64/gcc4.8:/opt/intel/oneapi/mkl/latest/lib/intel64'
ENV LIBRARY_PATH='/opt/intel/oneapi/tbb/latest/lib/intel64/gcc4.8:/opt/intel/oneapi/mkl/latest/lib/intel64'
ENV MKLROOT='/opt/intel/oneapi/mkl/latest'

# Copy
COPY --from=builder /opt/bin /opt

# Install frameworks
RUN  ls /opt/*whl | xargs python3 -m pip install

# Copy tune
COPY . /opt/tune

WORKDIR /opt/tune
RUN python3 -m pip install -r requirements.txt

WORKDIR /opt/tune
RUN python3 -m pip install -r requirements.txt