# Copyright (C) 2021-2022 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

ARG OV_TAG="2022.1.0"

################################################################################
FROM nncv-harbor.inn.intel.com/openvino/ubuntu18_dev:${OV_TAG}
################################################################################

LABEL description="This is the Ubuntu based dockerfile that builds CXX11 Python 3.x wheels \
                   for Intel(R) OpenVINO(TM) integration with TensorFlow"
LABEL vendor="Intel Corporation"

USER root

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

ARG OVTF_BRANCH="releases/2.0.0"

ADD rename_wheel.sh /

RUN apt-get update; \
    apt install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa; \
    apt-get install -y --no-install-recommends \
    git \
    zip \
    unzip \
    build-essential \
    ccache \
    python3.7-venv \
    python3.8-venv \
    python3.9-venv; \
    rm -rf /var/lib/apt/lists/*;

RUN apt-get update; \
    apt install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa; \
    apt-get install -y --no-install-recommends \
        python3.6-dev python3.7-dev python3.8-dev python3.9-dev && \
        curl -f https://bootstrap.pypa.io/get-pip.py | python3.7 - --no-cache-dir pip==22.0.4 && \
        curl -f https://bootstrap.pypa.io/get-pip.py | python3.8 - --no-cache-dir pip==22.0.4 && \
        curl -f https://bootstrap.pypa.io/get-pip.py | python3.9 - --no-cache-dir pip==22.0.4 && \
    rm -rf /var/lib/apt/lists/*;

# clone & build
RUN mkdir -p /opt/intel/openvino_tensorflow/

RUN git clone --quiet https://github.com/openvinotoolkit/openvino_tensorflow \
    /opt/intel/openvino_tensorflow

WORKDIR /opt/intel/openvino_tensorflow/

RUN git checkout ${OVTF_BRANCH} && git submodule update --init --recursive

# artifacts dir
RUN mkdir -p /whl/abi1/

RUN for py_ver in 3.7 3.8 3.9; do \
        python${py_ver} -m venv venv_${py_ver}; \
        source venv_${py_ver}/bin/activate; \
        # install build requirements
        pip3 install --no-cache-dir -r requirements.txt; \
        # start build
        python build_ovtf.py --python_executable=`which python` \
                             --cxx11_abi_version=1 \
                             --disable_packaging_openvino_libs \
                             --use_openvino_from_location=/opt/intel/openvino/ \
                             --build_dir=build_venv_${py_ver}; \
        # rename wheel to openvino_tensorflow_abi1
        source /rename_wheel.sh && \
        whl_rename build_venv_${py_ver}/artifacts/*.whl openvino_tensorflow_abi1 && \
        # copy to artifacts dir
        cp build_venv_${py_ver}/artifacts/openvino_tensorflow_abi1*.whl /whl/abi1/; \
        rm -rf build_venv_${py_ver}; \
        deactivate; \
    done
