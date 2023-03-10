ARG OS_VERSION=16.04
FROM ubuntu:${OS_VERSION}

ARG PYTHON_VERSION=3.5
ARG OPENVINO_VERSION=2020.2

ADD scripts /tmp/scripts
ENV PATH="/opt/cmake/bin:${PATH}"
RUN /tmp/scripts/install_ubuntu.sh -p $PYTHON_VERSION -d EdgeDevice && \
    /tmp/scripts/install_deps.sh -p $PYTHON_VERSION -d EdgeDevice

RUN apt update && apt install --no-install-recommends -y libnuma1 ocl-icd-libopencl1 && \
    rm -rf /var/lib/apt/lists/*

RUN /tmp/scripts/install_openvino.sh -o ${OPENVINO_VERSION} && \
    rm -rf /tmp/scripts

WORKDIR /root

ENV INTEL_OPENVINO_DIR /data/dldt/openvino_${OPENVINO_VERSION}
ENV LD_LIBRARY_PATH $INTEL_OPENVINO_DIR/deployment_tools/inference_engine/lib/intel64:$INTEL_OPENVINO_DIR/deployment_tools/:$INTEL_OPENVINO_DIR/deployment_tools/ngraph/lib:$INTEL_OPENVINO_DIR/deployment_tools/inference_engine/external/tbb/lib:/usr/local/openblas/lib:$LD_LIBRARY_PATH

ENV PYTHONPATH $INTEL_OPENVINO_DIR/tools:$PYTHONPATH
ENV IE_PLUGINS_PATH $INTEL_OPENVINO_DIR/deployment_tools/inference_engine/lib/intel64

RUN wget https://github.com/intel/compute-runtime/releases/download/19.15.12831/intel-gmmlib_19.1.1_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/19.15.12831/intel-igc-core_1.0.2-1787_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/19.15.12831/intel-igc-opencl_1.0.2-1787_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/19.15.12831/intel-opencl_19.15.12831_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/19.15.12831/intel-ocloc_19.15.12831_amd64.deb && \
    sudo dpkg -i *.deb && rm -rf *.deb

ARG BUILD_UID=1000
ARG BUILD_USER=onnxruntimedev
WORKDIR /home/$BUILD_USER
RUN adduser --gecos 'onnxruntime Build User' --disabled-password $BUILD_USER --uid $BUILD_UID
RUN adduser $BUILD_USER video
USER $BUILD_USER
