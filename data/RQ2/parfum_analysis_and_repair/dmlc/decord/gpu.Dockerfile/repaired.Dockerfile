FROM nvcr.io/nvidia/cuda:11.2.0-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && apt-get install --no-install-recommends -y \
    software-properties-common \
    build-essential \
    checkinstall \
    cmake \
    make \
    pkg-config \
    yasm \
    git \
    vim \
    curl \
    wget \
    sudo \
    apt-transport-https \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    dbus-x11 \
    iputils-ping \
    python3-dev \
    python3-pip \
    python3-setuptools && rm -rf /var/lib/apt/lists/*;

# some image/media dependencies
RUN apt-get -y update && apt-get install --no-install-recommends -y \
    libjpeg8-dev \
    libpng-dev \
    libtiff5-dev \
    libtiff-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libdc1394-22-dev \
    libxine2-dev \
    libavfilter-dev \
    libavutil-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y update && apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* && apt-get -y autoremove

ENV NVIDIA_DRIVER_CAPABILITIES=all
RUN ln -s /usr/lib/x86_64-linux-gnu/libnvcuvid.so.1 /usr/local/cuda/lib64/libnvcuvid.so
RUN git clone --recursive https://github.com/dmlc/decord
RUN cd decord && mkdir build && cd build && cmake .. -DUSE_CUDA=ON -DCMAKE_BUILD_TYPE=Release && make -j2 && cd ../python && python3 setup.py install
