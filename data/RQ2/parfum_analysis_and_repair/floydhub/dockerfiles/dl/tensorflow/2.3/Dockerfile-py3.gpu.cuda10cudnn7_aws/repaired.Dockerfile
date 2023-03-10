FROM floydhub/dl-base:4.1.0-gpu-py3.55
MAINTAINER Floyd Labs "support@floydhub.com"

ARG TENSORFLOW_VERSION=v2.3.1
ARG KERAS_VERSION=2.4.0

ENV CI_BUILD_PYTHON python

# Configure the build for our CUDA configuration.
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH
ENV TF_CUDA_VERSION 10.2
ENV TF_CUDNN_VERSION 7
ENV TF_NEED_CUDA 1
ENV TF_CUDA_COMPUTE_CAPABILITIES=3.7,7.0



# Fix build
ENV BAZEL_VERSION 3.1.0
RUN curl -f -LO "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel_${BAZEL_VERSION}-linux-x86_64.deb" \
    && dpkg --force-confnew -i bazel_*.deb \
    && apt-get clean \
    && rm bazel_*.deb

# install deps for tf build :(
RUN pip --no-cache-dir install \
        funcsigs \
        pbr \
        mock \
        wheel \
        keras_applications \
        keras_preprocessing \
        --no-deps \
    && rm -rf /pip_pkg \
    && rm -rf /tmp/* \
    && rm -rf /root/.cache


# NOTE: This command uses special flags to build an optimized image for AWS machines.
# This image might *NOT* work on other machines
# Clean up pip wheel and Bazel cache when done.
RUN git clone https://github.com/tensorflow/tensorflow.git \
        --branch ${TENSORFLOW_VERSION} \
        --single-branch \
    && cd tensorflow \
    && ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 && LD_LIBRARY_PATH=/usr/local/cuda/lib64/stubs:${LD_LIBRARY_PATH} tensorflow/tools/ci_build/builds/configured GPU \
        bazel build -c opt --copt=-msse3 --copt=-msse4.1 --copt=-msse4.2 \
            --copt=-mavx --copt=-mavx2 \
            --copt=-mfma \
            --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" \
            --config=cuda --action_env=LD_LIBRARY_PATH=/usr/local/cuda/lib64/stubs:${LD_LIBRARY_PATH} \
            --verbose_failures \
            tensorflow/tools/pip_package:build_pip_package \
    && bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/pip \
    && pip --no-cache-dir install --upgrade /tmp/pip/tensorflow-*.whl \
    && rm -rf /pip_pkg \
    && rm -rf /tmp/* \
    && rm -rf /root/.cache \
    && cd .. && rm -rf tensorflow

# Install Keras
RUN pip --no-cache-dir install \
        git+git://github.com/fchollet/keras.git@${KERAS_VERSION} \
    && rm -rf /pip_pkg \
    && rm -rf /tmp/* \
    && rm -rf /root/.cache


# Fix Jupyterlab - see https://github.com/jupyter/jupyter/issues/401
# TODO: move this on dl-base
RUN pip --no-cache-dir install --upgrade notebook \
    && rm -rf /pip_pkg \
    && rm -rf /tmp/* \
    && rm -rf /root/.cache