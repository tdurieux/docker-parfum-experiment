#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
# 
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

FROM debian:bullseye-slim

# See https://github.com/intel/compute-runtime/releases
# should (hopefully) just need --device=/dev/dri
ENV OCL_VERSION 20.51.18762
ENV GMM_VERSION 20.3.2
ENV IGC_VERSION 1.0.5884

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    # Add the packages
    apt-get install -y --no-install-recommends \
    ocl-icd-libopencl1 clinfo wget ca-certificates && \
    # Add the Intel compute-runtime
    mkdir neo && cd neo && \
    wget "https://github.com/intel/compute-runtime/releases/download/${OCL_VERSION}/intel-opencl_${OCL_VERSION}_amd64.deb" && \
    wget "https://github.com/intel/compute-runtime/releases/download/${OCL_VERSION}/intel-ocloc_${OCL_VERSION}_amd64.deb" && \
    wget "https://github.com/intel/compute-runtime/releases/download/${OCL_VERSION}/intel-gmmlib_${GMM_VERSION}_amd64.deb" && \
    wget "https://github.com/intel/intel-graphics-compiler/releases/download/igc-${IGC_VERSION}/intel-igc-core_${IGC_VERSION}_amd64.deb" && \
    wget "https://github.com/intel/intel-graphics-compiler/releases/download/igc-${IGC_VERSION}/intel-igc-opencl_${IGC_VERSION}_amd64.deb" && \
    dpkg -i *.deb && \
    # Remove packages used for installation
    cd .. && rm -rf neo && \
    apt-get clean && \
    apt-get purge -y wget ca-certificates && \
    apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["clinfo"]

#-------------------------------------------------------------------------------
# Example usage
# 
# Build the image
# docker build -t clinfo-intel -f Dockerfile-intel-bullseye .