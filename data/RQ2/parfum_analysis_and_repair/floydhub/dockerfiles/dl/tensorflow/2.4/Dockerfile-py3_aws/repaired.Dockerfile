FROM floydhub/dl-base:4.1.0-py3.55
MAINTAINER Floyd Labs "support@floydhub.com"

ARG TENSORFLOW_VERSION=v2.4.1
ARG KERAS_VERSION=2.4.0

ENV CI_BUILD_PYTHON python



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
    && tensorflow/tools/ci_build/builds/configured CPU \
        bazel build -c opt --copt=-msse3 --copt=-msse4.1 --copt=-msse4.2 \
            --copt=-mavx --copt=-mavx2 \
            --copt=-mfma \
            --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" \
             \
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