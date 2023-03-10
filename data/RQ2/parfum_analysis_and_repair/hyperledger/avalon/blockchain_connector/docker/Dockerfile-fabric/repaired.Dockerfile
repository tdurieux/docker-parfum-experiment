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

ARG IMAGE
FROM $IMAGE as base_image
ARG DISTRO
COPY ./scripts/install_packages /project/avalon/scripts/
RUN packages=""; \
    pip_packages=""; \
    if [ "$DISTRO" = "bionic" ] ; then \
      DEBIAN_FRONTEND=noninteractive \
      packages="$packages ca-certificates python3-requests python3-toml python3-colorlog python3-twisted"; \
    elif [ "$DISTRO" = "centos" ] ; then \
      packages="$packages python3" \
      pip_packages="$pip_packages toml colorlog twisted requests"; \
      /project/avalon/scripts/install_packages -c install -q "epel-release"; \
    fi; \
    /project/avalon/scripts/install_packages -c install -q "$packages" -p "$pip_packages"

# Make Python3 default
RUN ln -sf /usr/bin/python3 /usr/bin/python

# -------------=== python build ===-------------

#Build python intermediate docker image
FROM $IMAGE as python_image
ARG DISTRO

COPY ./scripts/install_packages /project/avalon/scripts/

# Add necessary packages
RUN packages="ca-certificates pkg-config python3-pip make" \
    pip_packages="setuptools jsonschema"; \
    if [ "$DISTRO" = "bionic" ] ; then \
      packages="$packages python3-dev"; \
    elif [ "$DISTRO" = "centos" ] ; then \
      packages="$packages python3-devel" \
      pip_packages="$pip_packages wheel"; \
    fi; \
    /project/avalon/scripts/install_packages -c install -q "$packages" -p "$pip_packages"

# -------------=== common/python build ===-------------

#Build common/python intermediate docker image
FROM python_image as common_python_image

COPY VERSION /project/avalon/
COPY ./bin /project/avalon/bin

ENV TCF_HOME=/project/avalon

COPY ./common/python /project/avalon/common/python

WORKDIR /project/avalon/common/python

RUN echo "Building Avalon Common Python\n" \
 && make


# -------------=== common/crypto_utils build ===-------------

#Build common/crypto_utils intermediate docker image
FROM python_image as common_crypto_utils_image

COPY VERSION /project/avalon/
COPY ./bin /project/avalon/bin

ENV TCF_HOME=/project/avalon

COPY ./common/crypto_utils /project/avalon/common/crypto_utils

WORKDIR /project/avalon/common/crypto_utils

RUN echo "Building Avalon Common Crypto Python\n" \
 && make


# -------------=== Avalon SDK build ===-------------

#Build Avalon SDK intermediate docker image
FROM python_image as avalon_sdk_image

COPY VERSION /project/avalon/
COPY ./bin /project/avalon/bin
COPY ./sdk /project/avalon/sdk

ENV TCF_HOME=/project/avalon

WORKDIR /project/avalon/sdk

#install Avalon SDK  package.
RUN echo "Building Avalon SDK\n" \
 && make


# Build Avalon blockchain connector docker image
FROM python_image as build_image
ARG DISTRO

# Add necessary packages to build
RUN packages="cmake git swig"; \
    pip_packages="nest_asyncio"; \
    if [ "$DISTRO" = "bionic" ] ; then \
      packages="$packages protobuf-compiler libprotobuf-dev software-properties-common dh-autoreconf ocaml xxd ocamlbuild"; \
    elif [ "$DISTRO" = "centos" ] ; then \
      packages="$packages libcurl-devel gcc-c++ which"; \
    fi; \
    /project/avalon/scripts/install_packages -c install -q "$packages" -p "$pip_packages"

RUN if [ "$DISTRO" = "centos" ] ; then \
      /project/avalon/scripts/install_packages -c install -q "epel-release"; \
      dnf -y --enablerepo=powertools install protobuf-devel yum-utils ocaml ocaml-ocamlbuild dh-autoreconf; \
    fi

COPY VERSION /project/avalon/
COPY ./bin /project/avalon/bin
COPY ./blockchain_connector /project/avalon/blockchain_connector

# Copy Python build artifacts
COPY --from=common_python_image /project/avalon/common/python/dist/*.whl dist/
COPY --from=avalon_sdk_image /project/avalon/sdk/dist/*.whl dist/

# Install fabric python sdk
RUN git clone https://github.com/hyperledger/fabric-sdk-py.git \
  && cd fabric-sdk-py \
  && make install

WORKDIR /project/avalon/blockchain_connector/common
# install blockchain common connector module
RUN echo "Build common connector module" \
   && make


WORKDIR /project/avalon/blockchain_connector/fabric
# install fabric connector module
RUN echo "Build fabric connector module" \
   && make

# Build final image and install modules
FROM base_image as final_image
ARG DISTRO

ENV TCF_HOME=/project/avalon

WORKDIR /project/avalon/blockchain_connector

COPY --from=build_image /usr/local/ /usr/local
# Copy Python build artifacts
COPY --from=common_python_image /project/avalon/common/python/dist/*.whl dist/
COPY --from=avalon_sdk_image /project/avalon/sdk/dist/*.whl dist/
COPY --from=common_crypto_utils_image /project/avalon/common/crypto_utils/dist/*.whl dist/
COPY --from=build_image /project/avalon/blockchain_connector/common/dist/*.whl dist/
COPY --from=build_image /project/avalon/blockchain_connector/fabric/dist/*.whl dist/
COPY ./sdk/avalon_sdk/tcf_connector.toml /project/avalon/sdk/avalon_sdk/

RUN if [ "$DISTRO" = "centos" ] ; then \
      dnf remove -y python3; \
      packages="openssl-devel wget make gcc"; \
      /project/avalon/scripts/install_packages -c install -q "$packages"; \
      cd /tmp \
      && wget https://www.python.org/ftp/python/3.6.9/Python-3.6.9.tgz \
      && tar -xvzf Python-3.6.9.tgz \
      && cd Python-3.6.9 \
      && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
      && make \
      && make install; rm Python-3.6.9.tgz \
    fi

# Installing wheel file requires python3-pip package.
# python3-pip package will increase size of final docker image.
# So remove python3-pip package and dependencies.
RUN packages=""; \
    pip_packages="pycryptodomex ecdsa"; \
    if [ "$DISTRO" = "bionic" ] ; then \
      packages="$packages python3-pip"; \
    fi; \
    /project/avalon/scripts/install_packages -c install -q "$packages" -p "$pip_packages" \
    && echo "Install Common Python, SDK & Blockchain_connector packages\n" \
    && pip3 install --no-cache-dir dist/*.whl \
    && if [ "$DISTRO" = "bionic" ] ; then \
         echo "Remove unused packages from image\n" \
         /project/avalon/scripts/install_packages -c uninstall -q "$packages"; \
       fi
