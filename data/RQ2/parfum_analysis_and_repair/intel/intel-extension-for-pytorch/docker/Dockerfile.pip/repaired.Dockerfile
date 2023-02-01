# based onhttps://github.com/pytorch/pytorch/blob/master/Dockerfile
#
# NOTE: To build this you will need a docker version >= 19.03 and DOCKER_BUILDKIT=1
#
#       If you do not use buildkit you are not going to have a good time
#
#       For reference:
#           https://docs.docker.com/develop/develop-images/build_enhancements/

ARG UBUNTU_VERSION=20.04

FROM ubuntu:${UBUNTU_VERSION} as base

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8
ARG PYTHON=python3

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends --fix-missing \
    ${PYTHON} \
    ${PYTHON}-pip && rm -rf /var/lib/apt/lists/*;

RUN ${PYTHON} -m pip --no-cache-dir install --upgrade \
    pip \
    setuptools \
    psutil

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

ARG IPEX_VERSION=1.12.0
ARG PYTORCH_VERSION=1.12.0+cpu
ARG TORCHAUDIO_VERSION=0.12.0
ARG TORCHVISION_VERSION=0.13.0+cpu
ARG TORCH_CPU_URL=https://download.pytorch.org/whl/cpu/torch_stable.html
ARG IPEX_URL=https://software.intel.com/ipex-whl-stable

RUN \
    python -m pip install --no-cache-dir \
    torch==${PYTORCH_VERSION} torchvision==${TORCHVISION_VERSION} torchaudio==${TORCHAUDIO_VERSION} -f ${TORCH_CPU_URL} && \
    python -m pip install --no-cache-dir \
    intel_extension_for_pytorch==${IPEX_VERSION} -f ${IPEX_URL}
