# --------------------------------------------------------------
# Copyright(C) Xilinx Inc.
# Licensed under the MIT License.
# --------------------------------------------------------------
# Dockerfile to run ONNXRuntime with Vitis-AI integration

FROM xilinx/vitis-ai:latest

ARG ONNXRUNTIME_REPO=https://github.com/Microsoft/onnxruntime
ARG ONNXRUNTIME_BRANCH=master

ARG PYXIR_REPO=https://github.com/Xilinx/pyxir
ARG PYXIR_BRANCH=master

RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo git bash && rm -rf /var/lib/apt/lists/*;

ENV PATH /code/cmake-3.14.3-Linux-x86_64/bin:$PATH
ENV LD_LIBRARY_PATH /opt/xilinx/xrt/lib:$LD_LIBRARY_PATH

WORKDIR /code
RUN . $VAI_ROOT/conda/etc/profile.d/conda.sh &&\
    conda activate vitis-ai-tensorflow &&\
    git clone --single-branch --branch ${PYXIR_BRANCH} --recursive ${PYXIR_REPO} pyxir &&\
    cd pyxir && python3 setup.py install --use_vai_rt
RUN . $VAI_ROOT/conda/etc/profile.d/conda.sh &&\
    conda activate vitis-ai-tensorflow &&\
    git clone --single-branch --branch ${ONNXRUNTIME_BRANCH} --recursive ${ONNXRUNTIME_REPO} onnxruntime &&\
    /bin/sh onnxruntime/dockerfiles/scripts/install_common_deps.sh &&\
    cp onnxruntime/docs/Privacy.md /code/Privacy.md &&\
    cp onnxruntime/dockerfiles/LICENSE-IMAGE.txt /code/LICENSE-IMAGE.txt &&\
    cp onnxruntime/ThirdPartyNotices.txt /code/ThirdPartyNotices.txt &&\
    cd onnxruntime &&\
    /bin/sh ./build.sh --use_openmp --config RelWithDebInfo --enable_pybind --build_wheel --use_vitisai --parallel --update --build --build_shared_lib && \
    pip install --no-cache-dir /code/onnxruntime/build/Linux/RelWithDebInfo/dist/*-linux_x86_64.whl && \
    cd .. && \
    rm -rf onnxruntime cmake-3.14.3-Linux-x86_64
