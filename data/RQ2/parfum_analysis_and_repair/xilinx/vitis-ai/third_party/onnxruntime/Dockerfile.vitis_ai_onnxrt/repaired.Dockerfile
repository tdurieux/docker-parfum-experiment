# Copyright 2022 Xilinx Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Dockerfile to run ONNX Runtime with Vitis AI integration

ARG BASE_IMAGE=xilinx/vitis-ai:2.0.0
FROM $BASE_IMAGE

ARG ONNXRUNTIME_REPO=https://github.com/Microsoft/onnxruntime
ARG ONNXRUNTIME_BRANCH=v1.10.0

ARG PYXIR_REPO=https://github.com/Xilinx/pyxir
ARG PYXIR_BRANCH=rel-v0.3.3
ARG PYXIR_FLAGS="--use_vart_cloud_dpu --use_dpuczdx8g_vart"

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    sudo \
    git \
    bash \
    gcc-aarch64-linux-gnu && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PATH /code/cmake-3.21.0-linux-x86_64/bin:$PATH
ENV LD_LIBRARY_PATH /opt/xilinx/xrt/lib:$LD_LIBRARY_PATH

WORKDIR /code

# Install PyXIR
RUN . $VAI_ROOT/conda/etc/profile.d/conda.sh &&\
    conda activate vitis-ai-tensorflow &&\
    git clone --single-branch --branch ${PYXIR_BRANCH} --recursive ${PYXIR_REPO} pyxir &&\
    cd pyxir && python3 setup.py install ${PYXIR_FLAGS}

# Install ONNX Runtime
RUN . $VAI_ROOT/conda/etc/profile.d/conda.sh &&\
    conda activate vitis-ai-tensorflow &&\
    git clone --single-branch --branch ${ONNXRUNTIME_BRANCH} --recursive ${ONNXRUNTIME_REPO} onnxruntime &&\
    /bin/sh onnxruntime/dockerfiles/scripts/install_common_deps.sh &&\
    cp onnxruntime/docs/Privacy.md /code/Privacy.md &&\
    cp onnxruntime/dockerfiles/LICENSE-IMAGE.txt /code/LICENSE-IMAGE.txt &&\
    cp onnxruntime/ThirdPartyNotices.txt /code/ThirdPartyNotices.txt &&\
    cd onnxruntime &&\
    /bin/sh ./build.sh --use_openmp --config RelWithDebInfo --enable_pybind --build_wheel --use_vitisai --parallel --update --build --build_shared_lib
RUN . $VAI_ROOT/conda/etc/profile.d/conda.sh &&\
    conda activate vitis-ai-tensorflow && \
    pip install --no-cache-dir /code/onnxruntime/build/Linux/RelWithDebInfo/dist/*-linux_x86_64.whl && \
    cd /code && \
    rm -rf onnxruntime cmake-3.21.0-linux-x86_64

# Install some useful packages inside the vitis-ai-tensorflow conda environment
RUN . $VAI_ROOT/conda/etc/profile.d/conda.sh && \
    conda activate vitis-ai-tensorflow && \
    pip install --no-cache-dir pydot==1.4.1 onnx==1.9.0 pillow

# Make sure conda libraries are found before /usr/lib (necessary for librt-engine.so)
RUN echo "export LD_LIBRARY_PATH=\$CONDA_PREFIX/lib:\${LD_LIBRARY_PATH}" >> \
    /opt/vitis_ai/conda/envs/vitis-ai-tensorflow/etc/conda/activate.d/env_vars.sh
