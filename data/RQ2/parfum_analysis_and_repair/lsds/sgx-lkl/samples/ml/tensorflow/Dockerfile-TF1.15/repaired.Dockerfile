FROM alpine:3.10 AS builder

# Based on https://github.com/better/alpine-tensorflow/blob/master/Dockerfile
#
# Based on https://github.com/tatsushid/docker-alpine-py3-tensorflow-jupyter/blob/master/Dockerfile
# Changes:
# - Bumping versions of Bazel and Tensorflow
# - Add -Xmx to the Java params when building Bazel
# - Disable TF_GENERATE_BACKTRACE and TF_GENERATE_STACKTRACE

RUN apk add --no-cache \
        python3 \
        python3-tkinter \
        py3-numpy \
        py3-numpy-f2py \
        freetype \
        libpng \
        libjpeg-turbo \
        imagemagick \
        graphviz \
        git \
        bash \
        nss \
        nss-dev

RUN apk add --no-cache --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
        hdf5 \
        hdf5-dev

RUN apk add --no-cache --virtual=.build-deps \
        cmake \
        curl \
        freetype-dev \
        g++ \
        libjpeg-turbo-dev \
        libpng-dev \
        linux-headers \
        make \
        musl-dev \
        openblas-dev \
        patch \
        perl \
        python3-dev \
        py-numpy-dev \
        py3-scipy \
        py3-numpy \
        rsync \
        sed \
        swig \
        zip \
        unzip \
        openjdk8 \
        libarchive \
        curl

# Note: Cython is pinned as newer versions cannot compile h5py.
RUN cd /tmp \
    && pip3 install --no-cache-dir Cython~=0.29 \
    && pip3 install --no-cache-dir wheel keras requests \
    && $(cd /usr/bin && ln -s python3 python)

ENV JAVA_HOME /usr/lib/jvm/default-jvm
ENV BAZEL_VERSION 0.26.1

# Bazel download
RUN curl -f -SLO https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-dist.zip \
    && mkdir bazel-${BAZEL_VERSION} \
    && unzip -qd bazel-${BAZEL_VERSION} bazel-${BAZEL_VERSION}-dist.zip

# Bazel install
RUN cd bazel-${BAZEL_VERSION} \
    && sed -i -e 's/-classpath/-J-Xmx8192m -J-Xms128m -classpath/g' scripts/bootstrap/compile.sh \
    && EXTRA_BAZEL_ARGS=--host_javabase=@local_jdk//:jdk ./compile.sh \
    && cp -p output/bazel /usr/bin/

ENV TENSORFLOW_VERSION 1.15.2

# Download Tensorflow
RUN cd /tmp \
    && curl -f -SL https://github.com/tensorflow/tensorflow/archive/v${TENSORFLOW_VERSION}.tar.gz \
        | tar xzf -

# Build Tensorflow
RUN cd /tmp/tensorflow-${TENSORFLOW_VERSION} \
    && : musl-libc does not have "secure_getenv" function \
    && sed -i -e '/define TF_GENERATE_BACKTRACE/d' tensorflow/core/platform/default/stacktrace.h \
    && sed -i -e '/define TF_GENERATE_STACKTRACE/d' tensorflow/core/platform/default/stacktrace_handler.cc \
    && sed -i -e 's/int res = pthread_getname_np.*/int res=-1; return false;/g' tensorflow/core/platform/posix/env.cc \
    && sed -i -e '/\"ENABLE_BACKTRACES\": 1,/d' third_party/llvm/llvm.bzl \
    && sed -i -e '/\"HAVE_MALLINFO\": 1,/d' third_party/llvm/llvm.bzl \
    && sed -i -e '/\"HAVE_EXECINFO_H\": 1,/d' third_party/llvm/llvm.bzl \
    && sed -i -e '/\"HAVE_BACKTRACE\": 1,/d' third_party/llvm/llvm.bzl \
    && touch /usr/include/sys/sysctl.h \
    &&  CC_OPT_FLAGS="-mavx -mavx2 -mfma -mfpmath=both -msse4.2" \
        TF_NEED_JEMALLOC=1 \
        TF_NEED_GCP=0 \
        TF_NEED_HDFS=0 \
        TF_NEED_S3=0 \
        TF_ENABLE_XLA=0 \
        TF_NEED_GDR=0 \
        TF_NEED_VERBS=0 \
        TF_NEED_OPENCL=0 \
        TF_NEED_CUDA=0 \
        TF_NEED_MPI=0 \
        bash configure

RUN cd /tmp/tensorflow-${TENSORFLOW_VERSION} \
    && bazel build -c opt --config opt --host_copt=-w --copt=-w //tensorflow/tools/pip_package:build_pip_package

# Replace with    && bazel build --cxxopt=-g --copt=-g -c dbg --strip=never //tensorflow/tools/pip_package:build_pip_package
# to build with debug symbols.

# Add -s for verbose build output (Logs all invoked build commands)

RUN cd /tmp/tensorflow-${TENSORFLOW_VERSION} \
    && ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

# Create wheelhouse containing tensorflow and other libraries with their dependencies.
# gast is pinned due to https://github.com/tensorflow/autograph/issues/1.
RUN pip3 wheel --wheel-dir /tmp/wheelhouse \
    /tmp/tensorflow_pkg/tensorflow-${TENSORFLOW_VERSION}-cp37-cp37m-linux_x86_64.whl \
    gast==0.2.2

RUN cp /tmp/tensorflow_pkg/tensorflow-${TENSORFLOW_VERSION}-cp37-cp37m-linux_x86_64.whl /root

##############
# Main stage #
##############
FROM alpine:3.10

# 'requests' is needed by /tf-models.
RUN apk add --no-cache \
    git python3 py3-pip py3-numpy py3-requests \
    protobuf

RUN apk add --no-cache --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
    hdf5

COPY --from=builder /tmp/wheelhouse /tmp/wheelhouse

RUN pip3 install --no-cache-dir --no-index --find-links=/tmp/wheelhouse \
    tensorflow \
    && python3 -c 'import tensorflow'

# Comment out
#    && python3 -c 'import tensorflow'
# when building for a different platform/machine with instruction set extensions like AVX/SSE that are not supported on the build machine.

RUN rm -rf /tmp/*

# Clone Tensorflow models and benchmarks repositories
RUN git clone --depth 1 https://github.com/tensorflow/models.git /tf-models
RUN git clone --depth 1 https://github.com/tensorflow/benchmarks.git -b cnn_tf_v1.15_compatible /tf-benchmarks

ADD app app

ADD app/data/mnist data
