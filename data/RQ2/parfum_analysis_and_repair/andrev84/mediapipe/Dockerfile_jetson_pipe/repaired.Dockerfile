FROM nvcr.io/nvidia/l4t-base:r32.4.4
RUN apt-get update -y
RUN apt install --no-install-recommends -y wget curl git && rm -rf /var/lib/apt/lists/*;
RUN apt upgrade -y
# RUN cd ~ && mkdir bazel && cd bazel && wget https://github.com/bazelbuild/bazel/releases/download/3.4.0/bazel-3.4.0-dist.zip && sudo apt-get install build-essential openjdk-8-jdk python zip unzip && unzip bazel-3.4.0-dist.zip && env EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash ./compile.sh && cp ~/bazel/output/bazel /usr/local/bin/
WORKDIR /io
WORKDIR /mediapipe
ENV DEBIAN_FRONTEND=noninteractive
ARG HDF5_DIR="/usr/lib/aarch64-linux-gnu/hdf5/serial/"
ARG MAKEFLAGS=-j8

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        ffmpeg \
        git \
        wget \
        unzip \
        python3-dev \
        python3-opencv \
        python3-pip \
        libopencv-core-dev \
        libopencv-highgui-dev \
        libopencv-imgproc-dev \
        libopencv-video-dev \
        libopencv-calib3d-dev \
        libopencv-features2d-dev \
        software-properties-common && \
    add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update && apt-get install --no-install-recommends -y openjdk-8-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade setuptools
RUN pip3 install --no-cache-dir wheel
RUN pip3 install --no-cache-dir future
RUN apt update -y
RUN apt-get install --no-install-recommends libegl1-mesa-dev libgles2-mesa-dev libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U numpy==1.16.1 future==0.18.2 mock==3.0.5 h5py==2.10.0 keras_preprocessing==1.1.1 keras_applications==1.0.8 gast==0.2.2 futures protobuf pybind11

RUN pip3 install --no-cache-dir six
RUN pip3 install --no-cache-dir setuptools Cython wheel
RUN pip3 install --no-cache-dir numpy --verbose
RUN pip3 install --no-cache-dir h5py==2.10.0 --verbose
RUN pip3 install --no-cache-dir future==0.18.2 mock==3.0.5 h5py==2.10.0 keras_preprocessing==1.1.1 keras_applications==1.0.8 gast==0.2.2 futures protobuf pybind11 --verbose

#RUN pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v44 tensorflow
ARG TENSORFLOW_URL=https://developer.download.nvidia.com/compute/redist/jp/v44/tensorflow/tensorflow-2.3.1+nv20.11-cp36-cp36m-linux_aarch64.whl
ARG TENSORFLOW_WHL=tensorflow-2.3.1+nv20.11-cp36-cp36m-linux_aarch64.whl


RUN wget --quiet --show-progress --progress=bar:force:noscroll --no-check-certificate ${TENSORFLOW_URL} -O ${TENSORFLOW_WHL} && \
    pip3 install --no-cache-dir ${TENSORFLOW_WHL} --verbose && \
    rm ${TENSORFLOW_WHL}
RUN pip3 install --no-cache-dir tf_slim

#RUN ln -s /usr/bin/python3 /usr/bin/python

# Install bazel
ARG BAZEL_VERSION=3.7.1

RUN mkdir /bazel && cd /bazel && wget https://github.com/bazelbuild/bazel/releases/download/3.7.1/bazel-3.7.1-dist.zip && apt-get install -y --no-install-recommends build-essential openjdk-8-jdk python zip unzip && unzip bazel-3.7.1-dist.zip && env EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash ./compile.sh && cp /bazel/output/bazel /usr/local/bin/ && rm -rf /var/lib/apt/lists/*;



ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"
RUN echo "$PATH" && echo "$LD_LIBRARY_PATH"

RUN pip3 install --no-cache-dir pycuda --verbose
COPY . /mediapipe/
#RUN bazel build -c opt --define MEDIAPIPE_DISABLE_GPU=1 mediapipe/examples/desktop/demo:object_detection_tensorflow_demo
