ARG UBUNTU_VERSION=18.04

ARG ARCH=
ARG CUDA=10.1
FROM nvidia/cuda${ARCH:+-$ARCH}:${CUDA}-base-ubuntu${UBUNTU_VERSION} as base
# ARCH and CUDA are specified again because the FROM directive resets ARGs
# (but their default value is retained if set previously)
ARG ARCH
ARG CUDA
#ARG CUDNN=8.0.4.30-1
ARG CUDNN=7.6.5.32-1

ARG CUDNN_MAJOR_VERSION=7
ARG LIB_DIR_PREFIX=x86_64
ARG LIBNVINFER=7.1.3-1
ARG LIBNVINFER_MAJOR_VERSION=7

# Needed for string substitution
SHELL ["/bin/bash", "-c"]
# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cuda-command-line-tools-${CUDA/./-} \
        libcublas10=10.2.1.243-1 \
        cuda-nvrtc-${CUDA/./-} \
        cuda-cufft-${CUDA/./-} \
        cuda-curand-${CUDA/./-} \
        cuda-cusolver-${CUDA/./-} \
        cuda-cusparse-${CUDA/./-} \
        curl \
        libcudnn7=${CUDNN}+cuda${CUDA} \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
        pkg-config \
        software-properties-common \
        unzip \
        netbase && rm -rf /var/lib/apt/lists/*;

# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV LANG C.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3.8 \
    python3-pip && rm -rf /var/lib/apt/lists/*;

RUN python3.8 -m pip --no-cache-dir install --upgrade \
    "pip<20.3" \
    setuptools

COPY requirements.txt /tmp
# RUN cd /tmp && pipenv lock --requirements > requirements.txt
RUN cd /tmp && pip install --no-cache-dir -r requirements.txt
COPY . /tmp/myapp
RUN pip install --no-cache-dir /tmp/myapp

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.3/wait /tmp/myapp/wait
RUN chmod +x /tmp/myapp/wait
#RUN groupadd -g 999 celery && \
#    useradd -r -u 999 -g celery celery
#USER celery

EXPOSE 5000
WORKDIR /tmp/myapp
COPY envs/env.docker .env

CMD alias python3=/usr/bin/python3.8
ENTRYPOINT ["/tmp/myapp/docker-entrypoint.sh"]