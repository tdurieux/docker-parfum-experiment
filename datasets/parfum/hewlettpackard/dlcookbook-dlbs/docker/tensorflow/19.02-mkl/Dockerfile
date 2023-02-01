# https://www.tensorflow.org/performance/performance_guide
FROM ubuntu:16.04

MAINTAINER Craig Citro <craigcitro@google.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
        numactl \
        build-essential \
        curl \
        git \
        libcurl3-dev \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python-dev \
        rsync \
        software-properties-common \
        unzip \
        zip \
        zlib1g-dev \
        openjdk-8-jdk \
        openjdk-8-jre-headless \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# This will install latest 'pip', 'setuptools' and 'wheel'.
RUN curl -fSsL -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install \
        absl-py \
        bleach \
        future \
        h5py \
        ipykernel \
        jupyter \
        matplotlib \
        numpy \
        pandas \
        protobuf \
        scikit-learn \
        scipy \
        six \
        sklearn \
        mock \
        && \
    python -m ipykernel.kernelspec

# I think this is required due to some bug (assuming this will build tensorflow/19.02-mkl: "d9d5ab289d08da9b3fa0a4feccf8dfa87a7b669e").
RUN pip install keras_applications==1.0.6 \
                keras_preprocessing==1.0.5 \
                tf-estimator-nightly==1.12.0.dev20181203 \
                --no-deps

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

# Jupyter has issues with being run directly:
#   https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh /

# Set up Bazel.

# Running bazel inside a `docker build` command causes trouble, cf:
#   https://github.com/bazelbuild/bazel/issues/134
# The easiest solution is to set up a bazelrc file forcing --batch.
RUN echo "startup --batch" >>/etc/bazel.bazelrc
# Similarly, we need to workaround sandboxing issues:
#   https://github.com/bazelbuild/bazel/issues/418
RUN echo "build --spawn_strategy=standalone --genrule_strategy=standalone" \
    >>/etc/bazel.bazelrc
# Install the most recent bazel release.
ENV BAZEL_VERSION 0.19.2
WORKDIR /
RUN mkdir /bazel && \
    cd /bazel && \
    curl -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36" -fSsL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    curl -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36" -fSsL -o /bazel/LICENSE.txt https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE && \
    chmod +x bazel-*.sh && \
    ./bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    cd / && \
    rm -f /bazel/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh

# Download and build TensorFlow.
ARG version=master
RUN git clone https://github.com/tensorflow/tensorflow.git && cd tensorflow &&\
    git reset --hard $version && git submodule update
WORKDIR /tensorflow

# Configure the build for our CUDA configuration.
ENV CI_BUILD_PYTHON python
ENV TF_NEED_CUDA 0
ENV TF_NEED_MKL 1
ENV TF_DOWNLOAD_MKL 1

# https://software.intel.com/en-us/articles/intel-optimization-for-tensorflow-installation-guide

RUN tensorflow/tools/ci_build/builds/configured CPU \
    bazel build -c opt --config=opt --config=mkl \
      tensorflow/tools/pip_package:build_pip_package && \
      bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/pip && \
    pip --no-cache-dir install --upgrade /tmp/pip/tensorflow-*.whl && \
    rm -rf /tmp/pip && \
    rm -rf /root/.cache
# Clean up pip wheel and Bazel cache when done.

WORKDIR /root

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

CMD ["/bin/bash"]
