FROM tensorflow/tensorflow:latest-devel

RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=America/Los_Angeles apt-get install -y --no-install-recommends \
        vim \
        cmake \
        python3-opencv \
        python3-progressbar \
        python3.6-dbg \
        gdb \
        graphviz && rm -rf /var/lib/apt/lists/*;

RUN cd / && \
    rm -rf /tensorflow_src && \
    git clone https://github.com/tensorflow/tensorflow.git /tensorflow_src && \
    cd /tensorflow_src && \
    git checkout -b tflite-vitisai-delegate-r2.3 ee598066c4cb31ec5ed3106e61ba99ef004a4bae && \
    mkdir -p /tensorflow_src/tensorflow/lite/delegates/vitisai

RUN cd /tensorflow_src/tensorflow/lite/delegates/vitisai && \
    git clone https://github.com/Xilinx/pyxir.git

RUN cd /tensorflow_src/tensorflow/lite/delegates/vitisai/pyxir && \
    git checkout -b tflite-vitisai-delegate-r2.3 986c53f5d87d6175518fd664b1937a11f5647565

COPY vitisai/pyxir/BUILD /tensorflow_src/tensorflow/lite/delegates/vitisai/pyxir
COPY vitisai/pyxir/python/libpyxir.so /tensorflow_src/tensorflow/lite/delegates/vitisai/pyxir/python

COPY vitisai/BUILD /tensorflow_src/tensorflow/lite/delegates/vitisai
COPY vitisai/vitisai_delegate.h /tensorflow_src/tensorflow/lite/delegates/vitisai
COPY vitisai/vitisai_delegate.cc /tensorflow_src/tensorflow/lite/delegates/vitisai

ARG BAZEL_VERSION=3.1.0
RUN rm -rf /bazel && \
    mkdir /bazel && \
    wget -O /bazel/installer.sh "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh" && \
    wget -O /bazel/LICENSE.txt "https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE" && \
    chmod +x /bazel/installer.sh && \
    /bazel/installer.sh && \
    rm -f /bazel/installer.sh

RUN cd /tensorflow_src && \
    bazel build --config=elinux_aarch64 -c dbg --local_ram_resources=2048 //tensorflow/lite/delegates/vitisai:libvitisai_delegate.so
