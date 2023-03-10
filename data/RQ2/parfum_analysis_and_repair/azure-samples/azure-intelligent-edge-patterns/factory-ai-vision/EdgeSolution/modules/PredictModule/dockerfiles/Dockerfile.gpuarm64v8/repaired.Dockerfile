# =========================================================
# Base
# =========================================================
ARG BASE_IMAGE=nvcr.io/nvidia/cuda-arm64:11.1-devel-ubuntu18.04
FROM ${BASE_IMAGE} as base

WORKDIR /app
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ARG SYSTEM_CORES=8

# =========================================================
# Install system packages
# =========================================================
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    wget \
    unzip \
    yasm \
    pkg-config \
    libtbb2 \
    libtbb-dev \
    libpq-dev \
    libprotobuf-dev \
    protobuf-compiler \
    libgeos-dev \
    ca-certificates \
    bzip2 \
    unzip \
    curl \
    libcurl4-openssl-dev \
    libssl-dev && \
    rm -rf /var/lib/apt/lists/*
# protobuf-compiler:   https://github.com/onnx/onnx#build-onnx-on-arm-64
# libprotobuf-dev:     https://github.com/onnx/onnx#build-onnx-on-arm-64
# libgeos-dev:         Shapely

# =========================================================
# Install Python package
# =========================================================
# WORKDIR /code/
# ARG MINIFORGE_VERSION=4.8.2-1
# ENV CONDA_DIR=/opt/conda
# ENV PATH=${CONDA_DIR}/bin:${PATH}

# RUN wget --no-hsts \
#     --quiet \
#     https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-${MINIFORGE_VERSION}-Linux-aarch64.sh \
#     -O /tmp/miniforge.sh && \
#     /bin/bash /tmp/miniforge.sh \
#     -b \
#     -p ${CONDA_DIR} && \
#     rm /tmp/miniforge.sh && \
#     conda clean -tipsy && \
#     find ${CONDA_DIR} -follow -type f -name '*.a' -delete && \
#     find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete && \
#     conda clean -afy

# RUN conda create --name python38 python=3.8 && \
#     echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate python38" >> /etc/skel/.bashrc && \
#     echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate python38" >> ~/.bashrc
# SHELL ["/bin/bash", "-c"]

# =========================================================
# Install Python package
# =========================================================
WORKDIR /app
COPY requirements/base.txt ./requirements/base.txt
RUN echo "/usr/bin/make --jobs=${SYSTEM_CORES} \$@" > /usr/local/bin/make && \
    chmod 755 /usr/local/bin/make
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir wheel cython protobuf
# Workaround scikit image requires numpy while dependency is not resolved
# RUN --mount=type=cache,target=/root/.cache/pip source activate python38 && pip install $(cat ./requirements/base.txt | grep numpy)
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir $(cat ./requirements/base.txt | grep numpy)
# RUN --mount=type=cache,target=/root/.cache/pip source activate python38 && pip install -r requirements/base.txt
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir -r requirements/base.txt

# =========================================================
# Install onnxruntime
# =========================================================
ARG ONNXRUNTIME_REPO="https://github.com/Microsoft/onnxruntime"
ARG ONNXRUNTIME_SERVER_BRANCH="rel-1.5.2"
ARG CMAKE_VERSION="3.14.3"
ARG CMAKE_TAR_LINK="https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz"

WORKDIR /code

RUN wget --no-hsts \
    --quiet \
    "${CMAKE_TAR_LINK}" &&\
    tar zxf "cmake-${CMAKE_VERSION}.tar.gz" &&\
    rm "cmake-${CMAKE_VERSION}.tar.gz"

RUN cd /code/cmake-${CMAKE_VERSION} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --system-curl --parallel=${SYSTEM_CORES} && \
    make -j${SYSTEM_CORES} && \
    make install && \
    cd /code && \
    rm -rf /code/cmake-${CMAKE_VERSION}

WORKDIR /code

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    libcudnn8=8.0.5.39-1+cuda11.1 \
    libcudnn8-dev=8.0.5.39-1+cuda11.1 \
    && rm -rf /var/lib/apt/lists/*
RUN git clone \
    --single-branch \
    --branch ${ONNXRUNTIME_SERVER_BRANCH} \
    --recursive ${ONNXRUNTIME_REPO} onnxruntime && \
    cd onnxruntime && \
    # source activate python38 && \
    /bin/sh ./build.sh \
    --use_openmp \
    --config Release \
    --build_wheel \
    --update \
    --build \
    --parallel \
    --use_cuda \
    --cuda_home /usr/local/cuda \
    --cudnn_home /usr/lib/aarch64-linux-gnu \
    --cmake_extra_defines ONNXRUNTIME_VERSION=$(cat ./VERSION_NUMBER) && \
    pip install --no-cache-dir /code/onnxruntime/build/Linux/Release/dist/*.whl && \
    cd .. && \
    rm -rf onnxruntime

# =========================================================
# Install opencv
# =========================================================
WORKDIR /app
COPY requirements/gpuarm64v8.txt ./requirements/gpuarm64v8.txt
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir -r requirements/gpuarm64v8.txt

# =========================================================
# Copy Source Code
# =========================================================
WORKDIR /app

COPY coco_classes.txt ./
COPY default_model default_model/
COPY default_model_6parts default_model_6parts/
COPY sample_video sample_video/
COPY scenario_models scenario_models/
RUN chmod 777 sample_video/video.mp4
RUN chmod 777 default_model

COPY api/__init__.py ./api/__init__.py
COPY api/models.py ./api/models.py
COPY config.py ./
COPY exception_handler.py ./
COPY logging_conf/logging_config.py ./logging_conf/logging_config.py
COPY model_wrapper.py ./
COPY object_detection.py ./
COPY object_detection2.py ./
COPY onnxruntime_predict.py ./
COPY server.py ./
COPY utility.py ./

EXPOSE 7777

CMD [ "python3", "server.py"]
