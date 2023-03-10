# ----- L4T_IMAGE ------
# Specify an image with the same tag as your host's Jetpack version.
# [Example]
# $ cat /etc/nv_tegra_release
# >> R32 (release), REVISION: 5.0, GCID: 25531747, BOARD: t186ref, EABI: aarch64, DATE: Fri Jan 15 23:21:05 UTC 2021
# In this case, use r32.5.0
# (ex. use r32.5.0)
# $ docker build --build-arg L4T_IMAGE=nvcr.io/nvidia/l4t-pytorch:r32.5.0-pth1.6-py3

# ----- JETSON_PLATFORM -----
# <platform> identifies the platform’s processor:
# t186 for Jetson TX2 series
# t194 for Jetson AGX Xavier series or Jetson Xavier NX
# t210 for Jetson Nano devices or Jetson TX1
# (ex. In this case, use AGX Xavier)
# $ docker build --build-arg L4T_IMAGE=nvcr.io/nvidia/l4t-pytorch:r32.5.0-pth1.6-py3 --build-arg JETSON_PLATFORM=t194

ARG L4T_IMAGE=nvcr.io/nvidia/l4t-pytorch:r32.4.4-pth1.6-py3
ARG JETSON_PLATFORM=t194

FROM ${L4T_IMAGE}

ARG L4T_IMAGE
ARG JETSON_PLATFORM

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y gnupg2 curl ca-certificates && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN L4T_REPO_VERSION=`python3 -c 'import sys; print(".".join((sys.argv[1].split(":")[-1]).split("-")[0].split(".")[:2]))' ${L4T_IMAGE}` &&\
    touch /etc/apt/sources.list.d/nvidia-l4t-apt-source.list &&\
    echo "deb https://repo.download.nvidia.com/jetson/common ${L4T_REPO_VERSION} main" >> /etc/apt/sources.list.d/nvidia-l4t-apt-source.list &&\
    echo "deb https://repo.download.nvidia.com/jetson/${JETSON_PLATFORM} ${L4T_REPO_VERSION} main" >> /etc/apt/sources.list.d/nvidia-l4t-apt-source.list &&\
    curl -fsSL https://repo.download.nvidia.com/jetson/jetson-ota-public.asc | apt-key add - &&\
    apt-get update && \
    apt-get install --no-install-recommends -y build-essential make cmake cmake-curses-gui unzip \
                        git g++ pkg-config curl \
                        python3-dev python3-testresources python3-pip \
                        python3-numpy python3-tk ffmpeg libsm6 libxext6 \
                        libopencv-python libopencv-dev && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN ln -svf /usr/bin/python3 /usr/bin/python
RUN python -m pip install --upgrade --force pip

# # Install dependencies
RUN pip install --no-cache-dir cython pillow matplotlib GitPython termcolor tensorboard
RUN pip install --no-cache-dir git+https://github.com/haotian-liu/cocoapi.git#"egg=pycocotools&subdirectory=PythonAPI"

# torch2trt
WORKDIR /root
RUN git clone https://github.com/NVIDIA-AI-IOT/torch2trt &&\
    cd torch2trt &&\
    python setup.py install --plugins

WORKDIR /root
RUN ln -s /yolact_edge
RUN ln -s /datasets
WORKDIR /root/yolact_edge

ENV LANG C.UTF-8