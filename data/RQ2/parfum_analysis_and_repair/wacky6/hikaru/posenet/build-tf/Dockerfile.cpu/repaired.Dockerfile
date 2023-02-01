FROM ubuntu:bionic
LABEL maintainer="Jiewei Qian <qjw@wacky.one>"

USER root
WORKDIR /root/
RUN mkdir -p /output/

# system packages
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
RUN apt update \
    && apt install --no-install-recommends -y python3 build-essential curl ca-certificates unzip \
    && ln -s /usr/bin/python3 /usr/bin/python && rm -rf /var/lib/apt/lists/*;

ENV TF_RELEASE=https://github.com/tensorflow/tensorflow/archive/v1.14.0.zip    \
    BAZEL_RELEASE=https://github.com/bazelbuild/bazel/releases/download/0.24.1/bazel-0.24.1-installer-linux-x86_64.sh    \
    CC_OPT_FLAGS='-march=native'

# bazel & tf binary
RUN curl -f -LO $BAZEL_RELEASE \
    && bash $( basename $BAZEL_RELEASE ) \
    && rm $( basename $BAZEL_RELEASE ) \
    && curl -f -LO $TF_RELEASE \
    && unzip $( basename $TF_RELEASE ) \
    && rm $( basename $TF_RELEASE )

# tensorflow build opts
ENV PYTHON_BIN_PATH=/usr/bin/python3    \
    PYTHON_LIB_PATH=/usr/local/lib/python3.6/dist-packages/    \
    TF_ENABLE_XLA=1    \
    TF_NEED_ROCM=0    \
    TF_NEED_CUDA=0    \
    TF_NEED_OPENCL_SYCL=0    \
    TF_NEED_COMPUTECPP=0    \
    TF_NEED_OPENCL=0    \
    TF_DOWNLOAD_CLANG=0 \
    TF_NEED_MPI=0    \
    TF_SET_ANDROID_WORKSPACE=0    \
    TF_CONFIGURE_IOS=0

ADD build.sh /root/

CMD ["/root/build.sh"]
