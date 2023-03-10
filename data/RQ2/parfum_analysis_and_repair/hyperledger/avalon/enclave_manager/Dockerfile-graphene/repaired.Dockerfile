# Copyright 2020 Intel Corporation
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
# ------------------------------------------------------------------------------

# Description:
#   Builds the environment needed to build Avalon Graphene Enclave manager.
#
#  Configuration (build) parameters
#  - proxy configuration: https_proxy http_proxy ftp_proxy
#  - sgx_mode:
#

# -------------=== build avalon Enclave Manager image ===-------------
# Build base docker image
FROM ubuntu:bionic as base_image

# Ignore timezone prompt in apt
ENV DEBIAN_FRONTEND=noninteractive

# Add necessary packages
RUN apt-get update \
 && apt-get install --no-install-recommends -y -q \
    ca-certificates \
    python3-toml \
    python3-requests \
    python3-colorlog \
    python3-twisted \
    python3-pip \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install setuptools packages using pip because
# these are not available in apt repository.
RUN pip3 install --no-cache-dir setuptools jsonschema

# Make Python3 default
RUN ln -sf /usr/bin/python3 /usr/bin/python



# -------------=== python build ===-------------

# Build python intermediate docker image
FROM ubuntu:bionic as python_image


# Add necessary packages
RUN apt-get update \
 && apt-get install --no-install-recommends -y -q \
    ca-certificates \
    pkg-config \
    python3-pip \
    python3-dev \
    make \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install setuptools packages using pip because
# these are not available in apt repository.
RUN pip3 install --no-cache-dir setuptools



# -------------=== common/python build ===-------------

# Build common/python intermediate docker image
FROM python_image as common_python_image

COPY VERSION /project/avalon/
COPY ./bin /project/avalon/bin

ENV TCF_HOME=/project/avalon

COPY ./common/python /project/avalon/common/python

WORKDIR /project/avalon/common/python

RUN echo "Building Avalon Common Python\n" \
 && make


# -------------=== common/crypto_utils build ===-------------

# Build common/crypto_utils intermediate docker image
FROM python_image as common_crypto_utils_image

RUN apt-get update \
 && apt-get install --no-install-recommends -y -q \
    swig && rm -rf /var/lib/apt/lists/*;

COPY VERSION /project/avalon/
COPY ./bin /project/avalon/bin

ENV TCF_HOME=/project/avalon

COPY ./common/crypto_utils /project/avalon/common/crypto_utils

WORKDIR /project/avalon/common/crypto_utils

RUN echo "Building Avalon Common Crypto Python\n" \
 && make


# -------------=== Avalon SDK build ===-------------

# Build Avalon SDK intermediate docker image
FROM python_image as avalon_sdk_image

COPY VERSION /project/avalon/
COPY ./bin /project/avalon/bin
COPY ./sdk /project/avalon/sdk

ENV TCF_HOME=/project/avalon

WORKDIR /project/avalon/sdk

# install Avalon SDK  package.
RUN echo "Building Avalon SDK\n" \
 && make


# Build Avalon Graphene manager intermediate image
FROM base_image as build_image

ENV TCF_HOME=/project/avalon
WORKDIR /project/avalon/enclave_manager

RUN apt-get update \
 && apt-get install --no-install-recommends -y -q python3-pip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY VERSION /project/avalon/
COPY ./bin /project/avalon/bin

# Copy Python build artifacts
COPY --from=common_python_image /project/avalon/common/python/dist/*.whl dist/
COPY --from=common_crypto_utils_image /project/avalon/common/crypto_utils/dist/*.whl dist/
COPY --from=avalon_sdk_image /project/avalon/sdk/dist/*.whl dist/

RUN echo "Install common/python and sdk packages\n" \
 && pip3 install --no-cache-dir dist/*.whl json-rpc pyzmq coverage pycryptodomex ecdsa


# Build Avalon Graphene Enclave Manager docker image
FROM build_image as final_image

ARG ENCLAVE_TYPE
ENV ENCLAVE_TYPE=${ENCLAVE_TYPE}
ENV TCF_HOME=/project/avalon

COPY ./config/graphene_wpe_config.toml /project/avalon/config/
COPY ./config/graphene_config.toml /project/avalon/config/
COPY ./config/tcs_config.toml /project/avalon/config/
COPY ./enclave_manager/setup_${ENCLAVE_TYPE}.py /project/avalon/enclave_manager/
COPY ./enclave_manager/avalon_enclave_manager/attestation_common /project/avalon/enclave_manager/avalon_enclave_manager/attestation_common
COPY ./enclave_manager/Makefile-graphene /project/avalon/enclave_manager/
COPY ./enclave_manager/avalon_enclave_manager/*.py /project/avalon/enclave_manager/avalon_enclave_manager/
COPY ./enclave_manager/avalon_enclave_manager/${ENCLAVE_TYPE} /project/avalon/enclave_manager/avalon_enclave_manager/${ENCLAVE_TYPE}
COPY ./enclave_manager/avalon_enclave_manager/wpe_common /project/avalon/enclave_manager/avalon_enclave_manager/wpe_common
COPY ./wpe_mr_enclave.txt /project/avalon/


WORKDIR /project/avalon/enclave_manager

RUN if [ "${ENCLAVE_TYPE}" != "graphene_wpe" ]; then rm -rf ./avalon_enclave_manager/wpe_common ./config/graphene_wpe_config.toml; fi

RUN echo "Build and Install Avalon Graphene Enclave Manager" \
  && make -f Makefile-graphene \
  && make -f Makefile-graphene install

