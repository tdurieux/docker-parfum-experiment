#
# This Dockerfile just installs pre-built ONNX Runtime wheel inside the image.
# Please make sure you have nvidia-runtime enabled in docker config and then build like:
#
# sudo -H DOCKER_BUILDKIT=1 nvidia-docker build --build-arg WHEEL_FILE=<path> -f Dockerfile.jetson
#

ARG BASE_IMAGE=nvcr.io/nvidia/l4t-base:r32.4.3
FROM ${BASE_IMAGE} as onnxruntime

ARG WHEEL_FILE
RUN echo "Building ONNX Runtime Docker image with ${WHEEL_FILE}..."

# Ensure apt-get won't prompt for selecting options
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y --no-install-recommends \
    	build-essential \
	software-properties-common \
	libopenblas-dev \
        libpython3.6-dev \
        python3-pip \
        python3-dev \
        cmake \
        unattended-upgrades && rm -rf /var/lib/apt/lists/*;
RUN unattended-upgrade
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir setuptools
RUN pip3 install --no-cache-dir wheel pybind11 pytest

WORKDIR /onnxruntime

# copy previously built wheel into the container
COPY ${WHEEL_FILE} .

RUN basename ${WHEEL_FILE} | xargs pip3 install
