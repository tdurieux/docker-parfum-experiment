#-------------------------------------------------------------------------
# Copyright(C) 2019 Intel Corporation.
# Licensed under the MIT License.
#--------------------------------------------------------------------------

FROM ubuntu:18.04

ARG DEVICE=CPU_FP32
ARG ONNXRUNTIME_REPO=https://github.com/microsoft/onnxruntime.git
ARG ONNXRUNTIME_BRANCH=master

WORKDIR /code
ARG MY_ROOT=/code

ENV PATH /opt/miniconda/bin:/code/cmake-3.14.3-Linux-x86_64/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/miniconda/lib:/usr/lib:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

ENV INTEL_OPENVINO_DIR=/opt/intel/openvino_2021.3.394
ENV InferenceEngine_DIR=${INTEL_OPENVINO_DIR}/deployment_tools/inference_engine/share
ENV IE_PLUGINS_PATH=${INTEL_OPENVINO_DIR}/deployment_tools/inference_engine/lib/intel64
ENV LD_LIBRARY_PATH=/opt/intel/opencl:${INTEL_OPENVINO_DIR}/inference_engine/external/gna/lib:${INTEL_OPENVINO_DIR}/deployment_tools/inference_engine/external/mkltiny_lnx/lib:$INTEL_OPENVINO_DIR/deployment_tools/ngraph/lib:${INTEL_OPENVINO_DIR}/deployment_tools/inference_engine/external/omp/lib:${INTEL_OPENVINO_DIR}/deployment_tools/inference_engine/external/tbb/lib:${IE_PLUGINS_PATH}:${LD_LIBRARY_PATH}
ENV OpenCV_DIR=${INTEL_OPENVINO_DIR}/opencv/share/OpenCV
ENV LD_LIBRARY_PATH=${INTEL_OPENVINO_DIR}/opencv/lib:${INTEL_OPENVINO_DIR}/opencv/share/OpenCV/3rdparty/lib:${LD_LIBRARY_PATH}
ENV HDDL_INSTALL_DIR=${INTEL_OPENVINO_DIR}/deployment_tools/inference_engine/external/hddl
ENV LD_LIBRARY_PATH=${INTEL_OPENVINO_DIR}/deployment_tools/inference_engine/external/hddl/lib:$LD_LIBRARY_PATH
ENV ngraph_DIR=${INTEL_OPENVINO_DIR}/deployment_tools/ngraph/cmake
ENV LANG en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive



RUN apt update && apt -y install --no-install-recommends apt-transport-https ca-certificates gnupg python3 python3-pip udev unzip zip x11-apps lsb-core wget curl cpio sudo libboost-python-dev libpng-dev zlib1g-dev git libnuma1 ocl-icd-libopencl1 clinfo libboost-filesystem1.65-dev libboost-thread1.65-dev protobuf-compiler libprotoc-dev autoconf automake libtool libjson-c-dev unattended-upgrades && \
    unattended-upgrade && \
    rm -rf /var/lib/apt/lists/* && \
    cd /opt && \
# libusb1.0.22
    curl -f -L https://github.com/libusb/libusb/archive/v1.0.22.zip --output v1.0.22.zip && \
    unzip v1.0.22.zip && \
    cd /opt/libusb-1.0.22 && \
# bootstrap steps
    ./bootstrap.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-udev --enable-shared && \
    make -j4 && \
    cd /opt/libusb-1.0.22/libusb && \
# configure libusb1.0.22
    /bin/mkdir -p '/usr/local/lib' && \
    /bin/bash ../libtool --mode=install /usr/bin/install -c   libusb-1.0.la '/usr/local/lib' && \
    /bin/mkdir -p '/usr/local/include/libusb-1.0' && \
    /usr/bin/install -c -m 644 libusb.h '/usr/local/include/libusb-1.0' && \
    /bin/mkdir -p '/usr/local/lib/pkgconfig' && \
# Install OpenVINO
    cd ${MY_ROOT} && \
    wget https://apt.repos.intel.com/openvino/2021/GPG-PUB-KEY-INTEL-OPENVINO-2021 && \
    apt-key add GPG-PUB-KEY-INTEL-OPENVINO-2021 && rm GPG-PUB-KEY-INTEL-OPENVINO-2021 && \
    cd /etc/apt/sources.list.d && \
    echo "deb https://apt.repos.intel.com/openvino/2021 all main">intel-openvino-2021.list && \
    apt update && \
    apt -y --no-install-recommends install intel-openvino-dev-ubuntu18-2021.3.394 && \
    cd ${INTEL_OPENVINO_DIR}/install_dependencies && ./install_openvino_dependencies.sh -y && \
    cd ${INTEL_OPENVINO_DIR} && rm -rf documentation data_processing && cd deployment_tools/ && rm -rf model_optimizer tools open_model_zoo demo && cd inference_engine && rm -rf samples && \
    cd /opt/libusb-1.0.22/ && \
    /usr/bin/install -c -m 644 libusb-1.0.pc '/usr/local/lib/pkgconfig' && \
    cp /opt/intel/openvino_2021/deployment_tools/inference_engine/external/97-myriad-usbboot.rules /etc/udev/rules.d/ && \
    ldconfig && \
# Install GPU runtime and drivers
    cd ${MY_ROOT} && \
    mkdir /tmp/opencl && \
    cd /tmp/opencl && \
    apt update && \
    apt install -y --no-install-recommends ocl-icd-libopencl1 && \
    rm -rf /var/lib/apt/lists/* && \
    wget "https://github.com/intel/compute-runtime/releases/download/19.41.14441/intel-gmmlib_19.3.2_amd64.deb" && \
    wget "https://github.com/intel/compute-runtime/releases/download/19.41.14441/intel-igc-core_1.0.2597_amd64.deb" && \
    wget "https://github.com/intel/compute-runtime/releases/download/19.41.14441/intel-igc-opencl_1.0.2597_amd64.deb" && \
    wget "https://github.com/intel/compute-runtime/releases/download/19.41.14441/intel-opencl_19.41.14441_amd64.deb" && \
    wget "https://github.com/intel/compute-runtime/releases/download/19.41.14441/intel-ocloc_19.41.14441_amd64.deb" && \
    dpkg -i /tmp/opencl/*.deb && \
    ldconfig && \
    rm -rf /tmp/opencl && \
    cd ${MY_ROOT} && \
    locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 && \
    pip3 install --no-cache-dir cython && \
# Download and build ONNX Runtime
    cd ${MY_ROOT} && \
    git clone --recursive -b ${ONNXRUNTIME_BRANCH} ${ONNXRUNTIME_REPO} && \
    /bin/sh onnxruntime/dockerfiles/scripts/install_common_deps.sh && \
    cd onnxruntime/cmake/external/onnx && python3 setup.py install && \
    cd ${MY_ROOT}/onnxruntime && ./build.sh --config Release --update --build --parallel --use_openvino ${DEVICE} --build_shared_lib --build_wheel && \
    pip install --no-cache-dir build/Linux/Release/dist/*-linux_x86_64.whl && \
    cd ${MY_ROOT}/ && rm -rf onnxruntime && cd /opt && rm -rf v1.0.22.zip && cd ${MY_ROOT} && \
    apt remove -y cmake && cd /usr/share/python-wheels/ && rm -rf *.whl && \
    cd /usr/lib/ && rm -rf python2.7 python3.6 python3.8 && cd && rm -rf .cache
