# Copyright (c) 2018-2019, NVIDIA CORPORATION. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#  * Neither the name of NVIDIA CORPORATION nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#
# Multistage build.
#

ARG BASE_IMAGE=tensorrtserver
ARG BUILD_IMAGE=tensorrtserver_build
ARG CLIENT_IMAGE=tensorrtserver_client
ARG INPROCESS_IMAGE=tensorrtserver_inprocess

############################################################################
## Copy artifacts from build container
############################################################################
FROM ${BUILD_IMAGE} AS build

# Update the qa/ directory with test executables, models, etc.
WORKDIR /workspace
RUN mkdir -p qa/common && \
    cp /opt/tensorrtserver/bin/caffe2plan qa/common/. && \
    mkdir qa/L0_simple_example/models && \
    cp -r docs/examples/model_repository/simple qa/L0_simple_example/models/. && \
    mkdir qa/L0_simple_string_example/models && \
    cp -r docs/examples/model_repository/simple_string qa/L0_simple_string_example/models/. && \
    mkdir -p qa/L0_simple_custom_example/models/simple/1 && \
    cp /opt/tensorrtserver/custom/libaddsub.so \
       qa/L0_simple_custom_example/models/simple/1/. && \
    mkdir -p qa/L0_simple_ensemble/models/ensemble_add_sub_int32_int32_int32/1 && \
    mkdir -p qa/L0_simple_ensemble/models/simple/1 && \
    cp /opt/tensorrtserver/custom/libaddsub.so \
       qa/L0_simple_ensemble/models/simple/1/. && \
    mkdir -p qa/L0_multiple_ports/models/simple/1 && \
    cp /opt/tensorrtserver/custom/libaddsub.so \
      qa/L0_multiple_ports/models/simple/1/. && \
    mkdir qa/L0_simple_inprocess/models && \
    cp -r docs/examples/model_repository/simple qa/L0_simple_inprocess/models/. && \
    mkdir -p qa/L0_custom_image_preprocess/models/image_preprocess_nhwc_224x224x3/1 && \
    cp /opt/tensorrtserver/custom/libimagepreprocess.so \
       qa/L0_custom_image_preprocess/models/image_preprocess_nhwc_224x224x3/1/. && \
    mkdir -p qa/L0_custom_param/models/param/1 && \
    cp /opt/tensorrtserver/custom/libparam.so \
       qa/L0_custom_param/models/param/1/. && \
    mkdir -p qa/L0_simple_sequence_example/models/simple_sequence/1 && \
    cp /opt/tensorrtserver/custom/libsequence.so \
       qa/L0_simple_sequence_example/models/simple_sequence/1/. && \
    cp /opt/tensorrtserver/custom/libidentity.so qa/L0_infer/. && \
    cp /opt/tensorrtserver/custom/libidentity.so qa/L0_infer_variable/. && \
    cp /opt/tensorrtserver/custom/libidentity.so qa/L0_infer_reshape/. && \
    cp /opt/tensorrtserver/custom/libidentity.so qa/L0_infer_zero/. && \
    cp /opt/tensorrtserver/custom/libidentity.so qa/L0_sequence_batcher/. && \
    mkdir -p qa/custom_models/custom_int32_int32_int32/1 && \
    cp /opt/tensorrtserver/custom/libaddsub.so \
       qa/custom_models/custom_int32_int32_int32/1/. && \
    mkdir -p qa/custom_models/custom_nobatch_int32_int32_int32/1 && \
    cp /opt/tensorrtserver/custom/libaddsub.so \
       qa/custom_models/custom_nobatch_int32_int32_int32/1/. && \
    mkdir -p qa/custom_models/custom_float32_float32_float32/1 && \
    cp /opt/tensorrtserver/custom/libaddsub.so \
       qa/custom_models/custom_float32_float32_float32/1/. && \
    mkdir -p qa/custom_models/custom_nobatch_float32_float32_float32/1 && \
    cp /opt/tensorrtserver/custom/libaddsub.so \
       qa/custom_models/custom_nobatch_float32_float32_float32/1/. && \
    mkdir -p qa/custom_models/custom_sequence_int32/1 && \
    cp /opt/tensorrtserver/custom/libsequence.so \
       qa/custom_models/custom_sequence_int32/1/.

# Generating the docs requires the docs source and the source code so
# copy that into L0_docs so that it is available when that test runs.
RUN cp VERSION qa/L0_docs/. && \
    cp README.rst qa/L0_docs/. && \
    cp -r docs qa/L0_docs/. && \
    cp -r src qa/L0_docs/.

############################################################################
## Copy artifacts from client container
############################################################################
FROM ${CLIENT_IMAGE} AS client

WORKDIR /workspace
COPY --from=build /workspace/qa/ qa/
RUN mkdir -p qa/clients && mkdir -p qa/pkgs && \
    cp /tmp/client/bin/* qa/clients/. && \
    cp /tmp/client/python/*.py qa/clients/. && \
    cp /tmp/client/python/tensorrtserver*.whl qa/pkgs/.

############################################################################
## Copy artifacts from in-process container
############################################################################
FROM ${INPROCESS_IMAGE} AS inprocess

WORKDIR /workspace
COPY --from=client /workspace/qa/ qa/
RUN cp build/simple_inprocess qa/L0_simple_inprocess/.

############################################################################
## Create CI enabled image
############################################################################
FROM $BASE_IMAGE

ARG PYVER=3.5

RUN apt-get update && apt-get install -y --no-install-recommends \
                              jmeter \
                              jmeter-http \
                              libcurl3 \
                              libopencv-dev \
                              libopencv-core-dev \
                              libpng12-dev \
                              libzmq3-dev \
                              python$PYVER \
                              python$PYVER-dev \
                              python$PYVER-numpy \
                              python`echo $PYVER | cut -c1-1`-pil \
                              python-protobuf \
                              swig && \
    rm -rf /var/lib/apt/lists/*

# Use the PYVER version of python
RUN rm -f /usr/bin/python && \
    rm -f /usr/bin/python`echo $PYVER | cut -c1-1` && \
    ln -s /usr/bin/python$PYVER /usr/bin/python && \
    ln -s /usr/bin/python$PYVER /usr/bin/python`echo $PYVER | cut -c1-1`

RUN curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python$PYVER get-pip.py && \
    rm get-pip.py
RUN pip install --no-cache-dir --upgrade numpy future grpcio

# CI expects tests in /opt/tensorrtserver/qa
WORKDIR /opt/tensorrtserver
COPY --from=inprocess /workspace/qa/ qa/

# Remove CI tests that are meant to run only on build image and
# install the tensorrtserver python client APIs.
RUN rm -fr qa/L0_copyrights qa/L0_unit_test qa/L1_tfs_unit_test && \
    pip install --no-cache-dir --upgrade qa/pkgs/tensorrtserver-*.whl

ENV PYVER ${PYVER}
