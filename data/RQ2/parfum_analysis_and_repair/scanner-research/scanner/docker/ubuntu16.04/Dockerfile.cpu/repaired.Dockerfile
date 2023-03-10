# Scanner base CPU image for Ubuntu 16.04

ARG base_tag
FROM ${base_tag}
MAINTAINER Will Crichton "wcrichto@cs.stanford.edu"
ARG cores=1

RUN bash ./deps.sh --root-install --install-all --without-openvino --prefix /usr/local && \
    rm -rf /opt/scanner-base

ENV PYTHONPATH /usr/local/python:${PYTHONPATH}
ENV PYTHONPATH /usr/local/lib/python3.5/site-packages:${PYTHONPATH}
ENV PYTHONPATH /usr/local/lib/python3.5/dist-packages:${PYTHONPATH}

#ENV INTEL_OPENVINO_DIR /usr/local/intel/openvino_2019.3.376
#ENV INTEL_CVSDK_DIR $INTEL_OPENVINO_DIR
#ENV InferenceEngine_DIR $INTEL_OPENVINO_DIR/deployment_tools/inference_engine/share
#ENV IE_PLUGINS_PATH $INTEL_OPENVINO_DIR/deployment_tools/inference_engine/lib/intel64
#ENV HDDL_INSTALL_DIR $INTEL_OPENVINO_DIR/deployment_tools/inference_engine/external/hddl
ENV Caffe_DIR /usr/local
#ENV LD_LIBRARY_PATH \
#       "$HDDL_INSTALL_DIR/lib:$INTEL_OPENVINO_DIR/deployment_tools/inference_engine/external/gna/lib:$INTEL_OPENVINO_DIR/deployment_tools/inference_engine/external/mkltiny_lnx/lib:$INTEL_OPENVINO_DIR/deployment_tools/inference_engine/external/tbb/lib:$IE_PLUGINS_PATH:$LD_LIBRARY_PATH"
#ENV PYTHONPATH /usr/local/intel/openvino_2019.3.376/python/python3.5:$PYTHONPATH