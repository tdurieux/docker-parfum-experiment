# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
FROM nvidia/cuda:11.2.1-base-ubuntu18.04 as base_build

ENV CUDNN_VERSION=8.1.0.77
ENV TF_TENSORRT_VERSION=7.2.2
ENV CUDA=11.2

RUN apt-get update && apt-get install -y --no-install-recommends \
        automake \
        build-essential \
        ca-certificates \
        cuda-command-line-tools-11-2 \
        libcublas-11-2 \
        libcublas-dev-11-2 \
        cuda-nvrtc-11-2 \
        cuda-nvrtc-dev-11-2 \
        cuda-nvprune-11-2 \
        cuda-cudart-dev-11-2 \
        libcufft-dev-11-2 \
        libcurand-dev-11-2 \
        libcusolver-dev-11-2 \
        libcusparse-dev-11-2 \
        curl \
        git \
        libfreetype6-dev \
        libtool \
        libcudnn8=${CUDNN_VERSION}-1+cuda${CUDA} \
        libcudnn8-dev=${CUDNN_VERSION}-1+cuda${CUDA} \
        libcurl3-dev \
        libzmq3-dev \
        mlocate \
        openjdk-8-jdk\
        openjdk-8-jre-headless \
        pkg-config \
        python-dev \
        software-properties-common \
        swig \
        unzip \
        wget \
        zip \
        zlib1g-dev \
        python3-distutils \
        python-distutils-extra \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    find /usr/local/cuda-11.2/lib64/ -type f -name 'lib*_static.a' -not -name 'libcudart_static.a' -delete && \
    rm /usr/lib/x86_64-linux-gnu/libcudnn_static_v8.a

# NOTE: libnvinfer uses cuda11.1 versions
RUN apt-get update && \
        apt-get install -y --no-install-recommends libnvinfer7=${TF_TENSORRT_VERSION}-1+cuda11.1 \
        libnvinfer-dev=${TF_TENSORRT_VERSION}-1+cuda11.1 \
        libnvinfer-plugin-dev=${TF_TENSORRT_VERSION}-1+cuda11.1 \
        libnvinfer-plugin7=${TF_TENSORRT_VERSION}-1+cuda11.1 \
        # TODO: need to verify
        libnvonnxparsers7=${TF_TENSORRT_VERSION}-1+cuda11.1 \
        libnvparsers7=${TF_TENSORRT_VERSION}-1+cuda11.1\
        libnvonnxparsers-dev=${TF_TENSORRT_VERSION}-1+cuda11.1 \
        libnvparsers-dev=${TF_TENSORRT_VERSION}-1+cuda11.1 \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*;

# Install python 3.6.
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3.6 python3.6-dev python3-pip python3.6-venv && \
    rm -rf /var/lib/apt/lists/* && \
    python3.6 -m pip install pip --upgrade && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 0

# Make python3.6 the default python version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 0

RUN curl -fSsL -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

RUN pip3 --no-cache-dir install \
    future>=0.17.1 \
    grpcio \
    h5py \
    keras_applications>=1.0.8 \
    keras_preprocessing>=1.1.0 \
    mock \
    numpy \
    portpicker \
    requests \
     --ignore-installed six>=1.12.0

FROM base_build as compile_build

# Set up Bazel
ENV BAZEL_VERSION 3.7.2
WORKDIR /
RUN mkdir /bazel && \
    cd /bazel && \
    curl -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36" -fSsL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    curl -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36" -fSsL -o /bazel/LICENSE.txt https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE && \
    chmod +x bazel-*.sh && \
    ./bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    cd / && \
    rm -f /bazel/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh

# Build TensorFlow with the CUDA configuration
ENV CI_BUILD_PYTHON python
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:/usr/local/cuda/lib64/stubs:/usr/include/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

ENV TF_NEED_CUDA 1
ENV TF_NEED_TENSORRT 1
ENV TENSORRT_INSTALL_PATH=/usr/lib/x86_64-linux-gnu
ENV TF_CUDA_VERSION=11.2
ENV TF_CUDNN_VERSION=8

# Fix paths so that CUDNN can be found: https://github.com/tensorflow/tensorflow/issues/8264
WORKDIR /
RUN mkdir /usr/lib/x86_64-linux-gnu/include/ && \
  ln -s /usr/include/cudnn.h /usr/local/cuda/include/cudnn.h && \
  ln -s /usr/lib/x86_64-linux-gnu/libcudnn.so /usr/local/cuda/lib64/libcudnn.so && \
  ln -s /usr/lib/x86_64-linux-gnu/libcudnn.so.${TF_CUDNN_VERSION} /usr/local/cuda/lib64/libcudnn.so.${TF_CUDNN_VERSION}

# cmake
RUN curl -f -L https://cmake.org/files/v3.15/cmake-3.15.7-Linux-x86_64.sh -o make-3.15.7-Linux-x86_64.sh
#COPY make-3.15.7-Linux-x86_64.sh ./
RUN chmod 777 make-3.15.7-Linux-x86_64.sh && \
	./make-3.15.7-Linux-x86_64.sh --skip-license --prefix=/usr

# For backward compatibility we need this line. After 1.13 we can safely remove
# it.
ENV TF_NCCL_VERSION=

# Set TMP for nvidia build environment
ENV TMP="/tmp"

# Download TF Serving sources (optionally at specific commit).
#ARG TF_SERVING_VERSION_GIT_COMMIT=2.5.2
#RUN curl -sSL --retry 5 https://github.com/tensorflow/serving/tarball/${TF_SERVING_VERSION_GIT_COMMIT} | tar --strip-components=1 -xzf -

# 补丁
COPY serving/ /tensorflow-serving/
COPY recommenders-addons/ /recommenders-addons/
COPY append_tfra_ops_on_tf_serving_source.sh /
RUN sh /append_tfra_ops_on_tf_serving_source.sh && cat /tensorflow-serving/WORKSPACE
ARG TF_VERSION="2.5.1"
RUN pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir tensorflow-gpu==${TF_VERSION}

#RUN mkdir /tf_lib && curl -L https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-gpu-linux-x86_64-${TF_VERSION}.tar.gz | tar xz --directory /tf_lib

WORKDIR /tensorflow-serving
# Build, and install TensorFlow Serving
ARG TF_SERVING_BUILD_OPTIONS="--config=release"
RUN echo "Building with build options: ${TF_SERVING_BUILD_OPTIONS}"
ARG TF_SERVING_BAZEL_OPTIONS="--remote_cache=grpc://bazel-cache.woa.com:9090"
RUN echo "Building with Bazel options: ${TF_SERVING_BAZEL_OPTIONS}"

RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 && \
    LD_LIBRARY_PATH=/usr/local/cuda/lib64/stubs:${LD_LIBRARY_PATH} \
    bazel build --jobs=10 --color=yes --curses=yes --config=cuda --copt="-fPIC"\
    ${TF_SERVING_BAZEL_OPTIONS} \
    --verbose_failures \
    --output_filter=DONT_MATCH_ANYTHING \
    ${TF_SERVING_BUILD_OPTIONS} \
    tensorflow_serving/model_servers:tensorflow_model_server && \
    cp bazel-bin/tensorflow_serving/model_servers/tensorflow_model_server \
    /usr/local/bin/ && \
    rm /usr/local/cuda/lib64/stubs/libcuda.so.1

## Build and install TensorFlow Serving API
#RUN bazel build --color=yes --curses=yes \
#    ${TF_SERVING_BAZEL_OPTIONS} \
#    --verbose_failures \
#    --output_filter=DONT_MATCH_ANYTHING \
#    ${TF_SERVING_BUILD_OPTIONS} \
#    tensorflow_serving/tools/pip_package:build_pip_package && \
#    bazel-bin/tensorflow_serving/tools/pip_package/build_pip_package \
#    /tmp/pip && \
#    pip --no-cache-dir install --upgrade \
#    /tmp/pip/tensorflow_serving_api_gpu-*.whl && \
#    rm -rf /tmp/pip

# Clean up Bazel cache when done.
# RUN bazel clean --expunge --color=yes && \
#    rm -rf /root/.cache

FROM base_build as final_build
# 换内网源
RUN echo "deb http://mirrors.tencent.com/ubuntu/ bionic main restricted universe multiverse\n \
deb http://mirrors.tencent.com/ubuntu/ bionic-security main restricted universe multiverse\n \
deb http://mirrors.tencent.com/ubuntu/ bionic-updates main restricted universe multiverse\n \
deb-src http://mirrors.tencent.com/ubuntu/ bionic main restricted universe multiverse\n \
deb-src http://mirrors.tencent.com/ubuntu/ bionic-security main restricted universe multiverse\n \
deb-src http://mirrors.tencent.com/ubuntu/ bionic-updates main restricted universe multiverse" > /etc/apt/sources.list

# 安装运维工具
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install --no-install-recommends -y vim apt-transport-https gnupg2 ca-certificates-java rsync jq wget git dnsutils iputils-ping net-tools curl locales zip unzip tzdata zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# 安装python
RUN apt install --no-install-recommends -y python3.6-dev python3-pip \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && ln -sf /usr/bin/pip3 /usr/bin/pip && rm -rf /var/lib/apt/lists/*;

# 安装中文
RUN apt install --no-install-recommends -y locales ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy && locale-gen zh_CN && locale-gen zh_CN.utf8 && rm -rf /var/lib/apt/lists/*;
ENV LANG zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8

# 设置时区
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# 便捷操作
RUN echo "alias ll='ls -alF'" >> /root/.bashrc && \
    echo "alias la='ls -A'" >> /root/.bashrc && \
    echo "alias vi='vim'" >> /root/.bashrc && \
    /bin/bash -c "source /root/.bashrc"

WORKDIR /app
COPY --from=compile_build /usr/local/bin/tensorflow_model_server /usr/local/bin/
RUN chmod 777 /usr/local/bin/tensorflow_model_server
#CMD ["sleep","99d"]
CMD ["/bin/bash", "-c", "cp -r /tmp/conf /tmp/conf_inner && tensorflow_model_server --model_config_file=$model_serving_config_path --port=8500 --rest_api_port=8501"]



