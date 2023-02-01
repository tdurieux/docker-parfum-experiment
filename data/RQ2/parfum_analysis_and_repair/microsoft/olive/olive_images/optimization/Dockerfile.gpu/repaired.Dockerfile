FROM nvidia/cuda:11.4.2-cudnn8-devel-ubuntu20.04

ARG ort_version

RUN apt-get -y update && apt-get -y upgrade

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:/code/cmake-3.21.0-linux-x86_64/bin:/opt/miniconda/bin:${PATH}
ENV LD_LIBRARY_PATH /opt/miniconda/lib:$LD_LIBRARY_PATH

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo git bash unattended-upgrades wget && rm -rf /var/lib/apt/lists/*;
RUN unattended-upgrade

# Install python3
RUN apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-dev \
    python3-wheel &&\
    cd /usr/local/bin &&\
    ln -s /usr/bin/python3 python &&\
    ln -s /usr/bin/pip3 pip; rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir setuptools >=41.0.0

# Install TensorRT
RUN v="8.2.1-1+cuda11.4" &&\
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub &&\
    apt-get update && \
    sudo apt-get install --no-install-recommends -y libnvinfer8=${v} libnvonnxparsers8=${v} libnvparsers8=${v} libnvinfer-plugin8=${v} \
        libnvinfer-dev=${v} libnvonnxparsers-dev=${v} libnvparsers-dev=${v} libnvinfer-plugin-dev=${v} \
        python3-libnvinfer=${v} && rm -rf /var/lib/apt/lists/*;


RUN python3 -m pip install --upgrade pip
COPY requirements.txt requirements.txt
RUN python3 -m pip install -r requirements.txt -f https://olivewheels.azureedge.net/test/mlperf-loadgen
RUN python3 -m pip install onnxruntime_gpu_tensorrt=="${ort_version}" -f https://olivewheels.azureedge.net/test/onnxruntime-gpu-tensorrt
RUN python3 -m pip install onnxruntime-olive==0.4.0 -f https://olivewheels.azureedge.net/test/onnxruntime-olive

ADD . /code
COPY licensing/LICENSE-IMAGE.txt /code/LICENSE-IMAGE.txt
COPY ThirdPartyNotices.txt /code/ThirdPartyNotices.txt

WORKDIR /mnt
