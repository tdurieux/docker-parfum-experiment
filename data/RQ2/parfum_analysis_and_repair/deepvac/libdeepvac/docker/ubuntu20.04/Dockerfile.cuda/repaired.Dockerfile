FROM nvidia/cuda:11.0.3-cudnn8-devel-ubuntu20.04
LABEL maintainer "Gemfield <gemfield@civilnet.cn>"
ARG PYTHON_VERSION=3.8

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" \
    apt-get install -y --no-install-recommends build-essential \
    vim wget curl bzip2 git unzip g++ binutils cmake locales \
    ca-certificates apt-transport-https gnupg software-properties-common \
    libjpeg-dev libpng-dev iputils-ping net-tools libgl1 libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
    apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
    echo "deb https://apt.repos.intel.com/mkl all main" > /etc/apt/sources.list.d/intel-mkl.list && \
    apt update && apt install --no-install-recommends -y intel-mkl-64bit-2020.4-912 && \
    rm -rf /var/lib/apt/lists/*

RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata && locale-gen zh_CN.utf8

ENV LC_ALL zh_CN.UTF-8
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8

#conda
RUN curl -f -o ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda install -y python=$PYTHON_VERSION conda-build anaconda-client numpy pyyaml scipy ipython mkl mkl-include \
        cffi ninja setuptools typing_extensions future six requests dataclasses cython typing conda-package-handling=1.6.0 && \
    /opt/conda/bin/conda install -c pytorch magma-cuda110 && \
    /opt/conda/bin/pip3 install --no-cache-dir Pillow opencv-python confluent_kafka easydict sklearn matplotlib tensorboard fonttools onnx-coreml coremltools && \
    /opt/conda/bin/conda clean -ya && \
    /opt/conda/bin/conda clean -y --force-pkgs-dirs

ENV PATH /opt/conda/bin:$PATH
RUN conda config --add channels pytorch

WORKDIR /gemfield
RUN curl -f -L https://github.com/opencv/opencv/archive/4.4.0.zip -o opencv.zip && \
    unzip opencv.zip && rm opencv.zip && cd opencv-4.4.0 && \
    mkdir /gemfield/opencv4deepvac && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_LIST=core,imgproc,imgcodecs -DCMAKE_INSTALL_PREFIX=/gemfield/opencv4deepvac -DBUILD_SHARED_LIBS=OFF .. && \
    make VERBOSE=1 && make install && cd /gemfield && rm -rf opencv-4.4.0

