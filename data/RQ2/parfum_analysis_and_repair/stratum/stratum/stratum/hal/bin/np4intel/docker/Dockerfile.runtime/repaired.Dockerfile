# Copyright 2019-present Dell EMC
# Copyright 2019-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0

#----------------------------------------------------------------------
# This Dockerfile builds a container image used to run the stratum_np4intel
# binary for use with the Intel PAC N3000 FPGA card.
#----------------------------------------------------------------------

ARG BUILDER_IMAGE
ARG OPAE_VERSION=1.3.6-4
ARG NP4_BIN
ARG NP4_DIR=/np4_intel
ARG PI_NP4_COMMIT="12be7a96f3d903afdd6cc3095f7d4003242af60b"

#----------------------------------------------------------------------
# Compile the stratum_np4intel binary
#----------------------------------------------------------------------

FROM $BUILDER_IMAGE as builder

# Copy stratum source code
ADD . /stratum

ENV OUTPUT_BASE /output/usr/local
ENV NP4_INSTALL /usr

WORKDIR /stratum

# Debug Stratum binary build
RUN bazel build //stratum/hal/bin/np4intel:stratum_np4intel \
    --compilation_mode=dbg && \
    cp bazel-bin/stratum/hal/bin/np4intel/stratum_np4intel /tmp/stratum_np4intel.debug

# Normal Stratum binary build
RUN bazel build //stratum/hal/bin/np4intel:stratum_np4intel

# Build the OPAE package
# Note: Will likely need to update these patches when updating the OPAE
#       version.
ARG OPAE_VERSION
ENV PATCHES_DIR=/stratum/stratum/hal/bin/np4intel/docker/patches
RUN git clone https://github.com/OPAE/opae-sdk.git /opae && \
    cd /opae && \
    git checkout $OPAE_VERSION && \
    patch tools/base/fpgainfo/bmcdata.c <${PATCHES_DIR}/bmcdata.c.patch && \
    patch CMakeLists.txt <${PATCHES_DIR}/CMakeLists.txt.patch && \
    patch cmake/modules/dependency_notifier.cmake \
        <${PATCHES_DIR}/dependency_notifier.cmake.patch && \
    mkdir mybuild && \
    cd mybuild && \
    cmake .. -DCPACK_GENERATOR=DEB -DCMAKE_INSTALL_PREFIX=/usr && \
    make package_deb

# Build PI python protobuf files
ARG PI_NP4_COMMIT
RUN git clone https://github.com/craigsdell/PI.git /tmp/PI && \
    cd /tmp/PI && \
    git checkout $PI_NP4_COMMIT && \
    git submodule update --init && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-proto && \
    make

# Build the forwarding pipeline protobuf
RUN cd /tmp/PI/proto && \
    mkdir -p stratum/hal && \
    cp /stratum/stratum/hal/lib/p4/forwarding_pipeline_configs.proto \
       stratum/hal/ && \
    protoc stratum/hal/forwarding_pipeline_configs.proto \
           --python_out py_out  -I ./ && \
    touch py_out/stratum/__init__.py && \
    touch py_out/stratum/hal/__init__.py && \
    mkdir -p /output/py_out/ && \
    cp -r py_out/ /output/ && \
    rm -rf /tmp/PI

# Copy into output build directory
ARG NP4_BIN
ARG NP4_DIR
ENV STRATUM_NP4INTEL_BASE stratum/hal/bin/np4intel
RUN mkdir -p $OUTPUT_BASE/bin && \
    mkdir -p $OUTPUT_BASE/share/stratum && \
    cp bazel-bin/$STRATUM_NP4INTEL_BASE/stratum_np4intel $OUTPUT_BASE/bin/ && \
    cp /tmp/stratum_np4intel.debug $OUTPUT_BASE/bin/ && \
    cp $STRATUM_NP4INTEL_BASE/docker/scripts/stratum-entrypoint.sh /output/ && \
    cp $STRATUM_NP4INTEL_BASE/docker/configs/stratum.flags $OUTPUT_BASE/share/stratum/ && \
    cp $STRATUM_NP4INTEL_BASE/docker/scripts/build_pipeline_configs.py /output/ && \
    mkdir /output/opae && \
    cp /opae/mybuild/opae-libs-${OPAE_VERSION}.x86_64.deb /output/opae/ && \
    cp -r $NP4_DIR /output/$NP4_DIR && \
    mkdir -p /output/stratum/hal/lib/common/ && \
    cp stratum/hal/lib/common/gnmi_caps.pb.txt /output/stratum/hal/lib/common/
    # TODO(Yi Tseng): Remove two lines above when we are able to generate cap response automatically

#----------------------------------------------------------------------
# Now build the stratum runtime container
#----------------------------------------------------------------------

FROM ubuntu:18.04
LABEL maintainer="Stratum dev <stratum-dev@lists.stratumproject.org>"
LABEL description="This Docker image is the base runtime for stratum_np4intel"

COPY --from=builder /output /

ARG JOBS

# Stratum Runtime dependencies
ENV PKG_DEPS pkg-config zip zlib1g-dev unzip python libboost-thread1.62.0 \
    ssh git sudo libelf-dev libssl1.1 iproute2 pciutils libjudydebian1 \
    libfdt1 libnuma-dev libhugetlbfs-dev libpcap-dev linux-virtual \
    vim python-pip dkms libjson-c3 apt-utils uuid-dev

RUN apt-get update && \
    apt-get install -y --no-install-recommends $PKG_DEPS && \
    ldconfig && rm -rf /var/lib/apt/lists/*;

# Install protobufs
# Note: needed to run build_pipeline_configs.py
RUN pip install --no-cache-dir setuptools wheel && \
    pip install --no-cache-dir protobuf

# Install the OPAE library
ARG OPAE_VERSION
RUN dpkg -i /opae/opae-libs-${OPAE_VERSION}.x86_64.deb

# Install the NP4 Intel packages
ARG NP4_BIN
ARG NP4_DIR
RUN bash $NP4_DIR/$NP4_BIN && \
    rm -rf /$NP4_DIR

# Setup stratum_np4intel pre-reqs
RUN mkdir /stratum_configs && \
    mkdir /stratum_logs && \
    mkdir /mnt/huge && \
    cd /lib/modules && \
    ln -s 4.15.0-72-generic `uname -r` && \
    echo "nodev /mnt/huge hugetlbfs defaults 0 0" >> /etc/fstab && \
    echo "vm.nr_hugepages=8192" >> /etc/sysctl.conf

EXPOSE 9339/tcp
EXPOSE 9559/tcp
ENTRYPOINT ["/stratum-entrypoint.sh"]

