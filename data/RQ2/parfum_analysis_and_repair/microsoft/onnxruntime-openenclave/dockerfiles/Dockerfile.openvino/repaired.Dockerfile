#-------------------------------------------------------------------------
# Copyright(C) 2019 Intel Corporation.
# Licensed under the MIT License.
#--------------------------------------------------------------------------

FROM ubuntu:18.04

ARG DEVICE=CPU_FP32
ARG ONNXRUNTIME_REPO=https://github.com/microsoft/onnxruntime
ARG ONNXRUNTIME_BRANCH=master

WORKDIR /code
ARG MY_ROOT=/code
ENV PATH /opt/miniconda/bin:/code/cmake-3.14.3-Linux-x86_64/bin:$PATH


ENV pattern="COMPONENTS=DEFAULTS"
ENV replacement="COMPONENTS=intel-openvino-ie-sdk-ubuntu-xenial__x86_64;intel-openvino-ie-rt-cpu-ubuntu-xenial__x86_64;intel-openvino-ie-rt-gpu-ubuntu-xenial__x86_64;intel-openvino-ie-rt-vpu-ubuntu-xenial__x86_64;intel-openvino-ie-rt-hddl-ubuntu-xenial__x86_64;intel-openvino-model-optimizer__x86_64;intel-openvino-opencv-lib-ubuntu-xenial__x86_64"
COPY l_openvino_*.tgz .
ENV LD_LIBRARY_PATH=/opt/miniconda/lib:/usr/lib:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
ENV INTEL_OPENVINO_DIR=/opt/intel/openvino_2020.3.194
ENV InferenceEngine_DIR=${INTEL_OPENVINO_DIR}/deployment_tools/inference_engine/share
ENV IE_PLUGINS_PATH=${INTEL_OPENVINO_DIR}/deployment_tools/inference_engine/lib/intel64
ENV LD_LIBRARY_PATH=/opt/intel/opencl:${INTEL_OPENVINO_DIR}/inference_engine/external/gna/lib:${INTEL_OPENVINO_DIR}/deployment_tools/inference_engine/external/mkltiny_lnx/lib:$INTEL_OPENVINO_DIR/deployment_tools/ngraph/lib:${INTEL_OPENVINO_DIR}/deployment_tools/inference_engine/external/omp/lib:${INTEL_OPENVINO_DIR}/deployment_tools/inference_engine/external/tbb/lib:${IE_PLUGINS_PATH}:${LD_LIBRARY_PATH}
ENV OpenCV_DIR=${INTEL_OPENVINO_DIR}/opencv/share/OpenCV
ENV LD_LIBRARY_PATH=${INTEL_OPENVINO_DIR}/opencv/lib:${INTEL_OPENVINO_DIR}/opencv/share/OpenCV/3rdparty/lib:${LD_LIBRARY_PATH}
ENV HDDL_INSTALL_DIR=${INTEL_OPENVINO_DIR}/deployment_tools/inference_engine/external/hddl
ENV LD_LIBRARY_PATH=${INTEL_OPENVINO_DIR}/deployment_tools/inference_engine/external/hddl/lib:$LD_LIBRARY_PATH
ENV LANG en_US.UTF-8

RUN apt update && \
    apt -y --no-install-recommends install git sudo wget locales \
    zip x11-apps lsb-core cpio libboost-python-dev libpng-dev zlib1g-dev libnuma1 ocl-icd-libopencl1 clinfo libboost-filesystem1.65-dev libboost-thread1.65-dev protobuf-compiler libprotoc-dev libusb-1.0-0-dev autoconf automake libtool libudev-dev libjson-c-dev && \
    cd ${MY_ROOT} && \
    git clone --recursive -b $ONNXRUNTIME_BRANCH $ONNXRUNTIME_REPO onnxruntime && \
    cp onnxruntime/docs/Privacy.md /code/Privacy.md && \
    cp onnxruntime/dockerfiles/LICENSE-IMAGE.txt /code/LICENSE-IMAGE.txt && \
    cp onnxruntime/ThirdPartyNotices.txt /code/ThirdPartyNotices.txt && \
    /bin/sh onnxruntime/dockerfiles/scripts/install_common_deps.sh && \
    cd onnxruntime/cmake/external/onnx && python3 setup.py install && \
    pip install --no-cache-dir azure-iothub-device-client azure-iothub-service-client azure-iot-provisioning-device-client && \
    cd ${MY_ROOT} && \
    tar -xzf l_openvino_toolkit*.tgz && \
    rm -rf l_openvino_toolkit*.tgz && \
    cd l_openvino_toolkit* && \
    sed -i "s/$pattern/$replacement/" silent.cfg && \
    sed -i 's/decline/accept/g' silent.cfg && \
    ./install.sh -s silent.cfg && \
    cd - && \
    rm -rf l_openvino_toolkit* && \
    cd /opt/intel/openvino/install_dependencies && ./install_openvino_dependencies.sh && ./install_NEO_OCL_driver.sh && dpkg -i *.deb && \
    cd ${MY_ROOT} && \
    locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 && \
    cd ${MY_ROOT} && \
    cd onnxruntime && ./build.sh --use_openmp --config Release --update --build --parallel --use_openvino $DEVICE --build_wheel --use_full_protobuf && \
    pip install --no-cache-dir build/Linux/Release/dist/*-linux_x86_64.whl && rm -rf /code/onnxruntime /code/cmake-3.14.3-Linux-x86_64 && rm -rf /var/lib/apt/lists/*;
