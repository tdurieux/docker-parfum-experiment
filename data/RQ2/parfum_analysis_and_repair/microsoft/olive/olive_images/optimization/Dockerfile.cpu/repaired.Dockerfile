FROM ubuntu:20.04

ARG ort_version
ARG OPENVINO_VERSION=2021.4

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y --no-install-recommends wget python3-dev python python3-pip gnupg && rm -rf /var/lib/apt/lists/*;

ENV INTEL_OPENVINO_DIR /opt/intel/openvino_${OPENVINO_VERSION}.752
ENV LD_LIBRARY_PATH $INTEL_OPENVINO_DIR/deployment_tools/inference_engine/lib/intel64:$INTEL_OPENVINO_DIR/deployment_tools/ngraph/lib:$INTEL_OPENVINO_DIR/deployment_tools/inference_engine/external/tbb/lib:/usr/local/openblas/lib:$LD_LIBRARY_PATH
ENV InferenceEngine_DIR $INTEL_OPENVINO_DIR/deployment_tools/inference_engine/share
ENV ngraph_DIR $INTEL_OPENVINO_DIR/deployment_tools/ngraph/cmake
ENV PYTHONPATH $INTEL_OPENVINO_DIR/tools:$PYTHONPATH
ENV IE_PLUGINS_PATH $INTEL_OPENVINO_DIR/deployment_tools/inference_engine/lib/intel64
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH /usr/local/gradle/bin:$PATH

RUN wget https://apt.repos.intel.com/openvino/2021/GPG-PUB-KEY-INTEL-OPENVINO-2021 && \
    apt-key add GPG-PUB-KEY-INTEL-OPENVINO-2021 && rm GPG-PUB-KEY-INTEL-OPENVINO-2021 && \
    cd /etc/apt/sources.list.d && \
    echo "deb https://apt.repos.intel.com/openvino/2021 all main">intel-openvino-2021.list && \
    apt update && \
    apt install --no-install-recommends -y intel-openvino-dev-ubuntu20-2021.4.752 && \
    cd ${INTEL_OPENVINO_DIR}/install_dependencies && ./install_openvino_dependencies.sh -y && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install --upgrade pip
COPY requirements.txt requirements.txt
RUN python3 -m pip install -r requirements.txt -f https://olivewheels.azureedge.net/test/mlperf-loadgen
RUN python3 -m pip install onnxruntime_openvino_dnnl=="$ort_version" -f https://olivewheels.azureedge.net/test/onnxruntime-openvino-dnnl
RUN python3 -m pip install onnxruntime-olive==0.4.0 -f https://olivewheels.azureedge.net/test/onnxruntime-olive

ADD . /code
COPY licensing/EULA.txt /code/EULA.txt
COPY licensing/ISSL.txt /code/ISSL.txt
COPY licensing/LICENSE-IMAGE.txt /code/LICENSE-IMAGE.txt
COPY licensing/redist.txt /code/redist.txt
COPY ThirdPartyNotices.txt /code/ThirdPartyNotices.txt

WORKDIR /mnt
