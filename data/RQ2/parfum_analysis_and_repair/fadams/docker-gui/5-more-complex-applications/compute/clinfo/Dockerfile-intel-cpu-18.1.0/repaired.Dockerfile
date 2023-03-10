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

FROM debian:stretch-slim

# Driver Version 18.1.0.0920
# Device Version OpenCL 2.1 (Build 0)
ENV RUNTIME l_opencl_p_18.1.0.013

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    # Add the packages
    apt-get install -y --no-install-recommends \
    ocl-icd-libopencl1 libnuma1 clinfo libxml2 \
    wget ca-certificates tar rpm2cpio cpio && \
    # Add the Intel OpenCL Installable Client Driver 
    wget -O ${RUNTIME}.tgz "https://registrationcenter-download.intel.com/akdlm/irc_nas/13793/${RUNTIME}.tgz" && \
    tar zxfp ${RUNTIME}.tgz && \
    cd ${RUNTIME}/rpm && \
    rpm2cpio intel-openclrt-18.1.0.013-18.1.0-013.x86_64.rpm | cpio -idmv && \
    mkdir -p /opt/intel && \
    mv ./opt/intel/opencl_compilers_and_libraries_18.1.0.013/linux/compiler/lib /opt/intel/opencl && \
    # Add ICD to the ICD registry
    mkdir -p /etc/OpenCL/vendors && \
    echo "/opt/intel/opencl/intel64_lin/libintelocl.so" > \
         /etc/OpenCL/vendors/intel_cpu.icd && \
    # Remove packages used for installation
    rm /${RUNTIME}.tgz && \
    rm -rf /${RUNTIME} && \
    apt-get clean && \
    apt-get purge -y wget ca-certificates rpm2cpio cpio && \
    apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["clinfo"]

#-------------------------------------------------------------------------------
# Example usage
#
# Build the image
# docker build -t clinfo-intel-cpu -f Dockerfile-intel-cpu-18.1.0 .

