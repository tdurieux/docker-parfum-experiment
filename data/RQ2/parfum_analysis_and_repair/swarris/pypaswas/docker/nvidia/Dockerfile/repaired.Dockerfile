FROM nvidia/cuda:8.0-devel-ubuntu16.04

MAINTAINER Marcel Kempenaar (m.kempenaar@pl.hanze.nl)

## OpenCL dependencies, runtime and development packages
RUN apt-get update && apt-get install -y --no-install-recommends \
	beignet ocl-icd-opencl-dev libffi-dev clinfo && \
    rm -rf /var/lib/apt/lists/*

## NVIDIA OpenCL support, taken from: https://gitlab.com/nvidia/opencl/blob/ubuntu14.04/runtime/Dockerfile
RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/cuda/lib:/usr/local/cuda/lib64

## Python3 and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-dev python3-pip python3-setuptools git opencl-headers \
    autoconf libtool pkg-config && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/local/cuda/lib64/libOpenCL* /usr/lib/ && \
    pip3 install --no-cache-dir --upgrade pip

RUN pip3 install --no-cache-dir wheel

RUN pip3 install --no-cache-dir numpy

RUN pip3 install --no-cache-dir biopython

RUN export PATH=/usr/local/cuda/bin:$PATH && pip3 install --no-cache-dir pycuda

RUN pip3 install --no-cache-dir pyopencl

## pyPaSWAS installation
RUN git clone https://github.com/swarris/pyPaSWAS.git /root/pyPaSWAS
