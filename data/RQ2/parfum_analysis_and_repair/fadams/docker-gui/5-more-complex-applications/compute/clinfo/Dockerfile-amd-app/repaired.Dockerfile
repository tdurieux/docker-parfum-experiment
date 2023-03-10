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

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    # Add the packages
    apt-get install -y --no-install-recommends \
    ocl-icd-libopencl1 clinfo \
    wget bzip2 ca-certificates tar && \
    # Add the AMD APP OpenCL Installable Client Driver
    mkdir -p /opt/amd/opencl/install && \
    cd /opt/amd/opencl/install && \
    wget -O AMD-APP-SDKInstaller-v3.0.130.136-GA-linux64.tar.bz2 "https://archive.org/download/AMDAPPSDK/AMD-APP-SDKInstaller-v3.0.130.136-GA-linux64.tar.bz2" && \
    tar xjf AMD-APP-SDKInstaller-v3.0.130.136-GA-linux64.tar.bz2 && \
    ./AMD-APP-SDK-v3.0.130.136-GA-linux64.sh --tar xvfp && \
    mv lib/x86_64/libamdocl12cl64.so /opt/amd/opencl && \
    mv lib/x86_64/sdk/libamdocl64.so /opt/amd/opencl && \
    # Add ICD to the ICD registry
    mkdir -p /etc/OpenCL/vendors && \
    echo "/opt/amd/opencl/libamdocl64.so" > \
         /etc/OpenCL/vendors/amdocl64.icd && \
    # Remove packages used for installation
    rm -rf /opt/amd/opencl/install && \
    apt-get clean && \
    apt-get purge -y wget bzip2 ca-certificates && \
    apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/* && rm AMD-APP-SDKInstaller-v3.0.130.136-GA-linux64.tar.bz2

ENTRYPOINT ["clinfo"]

#-------------------------------------------------------------------------------
# Example usage
#
# Build the image
# docker build -t clinfo-amd-app -f Dockerfile-amd-app .

